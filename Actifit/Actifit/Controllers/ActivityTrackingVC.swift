//
//  ActivityTrackingVC.swift
//  Actifit
//
//  Created by Hitender kumar on 03/08/18.
//  Copyright © 2018 actifit.io. All rights reserved.
//

import UIKit
import CoreMotion
import EFCountingLabel

let StepsUpdatedNotification = "StepsUpdatedNotification"

class ActivityTrackingVC: UIViewController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var stepsCountLabel : EFCountingLabel!
    @IBOutlet weak var postToSteemitBtn : UIButton!
    @IBOutlet weak var viewTrackingHistoryBtn : UIButton!
    @IBOutlet weak var viewDailyLeaderboardBtn : UIButton!
    @IBOutlet weak var viewWalletBtn : UIButton!
    @IBOutlet weak var settingsBtn : UIButton!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var usernameLabel : UILabel!
    @IBOutlet weak var rankLabel : UILabel!

    //MARK: INSTANCE VARIABLES
    
    let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    var startDate = Date()
    var timer : Timer?
    
    //MARK: View Life Cycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //stepsCountLabel.method = .easeInOut
        stepsCountLabel.format = "%d"
        if let activity = Activity.allWithoutCountZero().first(where: {$0.date == AppDelegate.todayStartDate()}) {
            self.showStepsCount(count: activity.steps)
        }
        
        self.postToSteemitBtn.layer.cornerRadius = 4.0
        self.viewTrackingHistoryBtn.layer.cornerRadius = 4.0
        self.viewDailyLeaderboardBtn.layer.cornerRadius = 4.0
        self.viewWalletBtn.layer.cornerRadius = 4.0
        self.settingsBtn.layer.cornerRadius = 4.0
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        
        getUSerRank()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        setTodayDate()
        self.navigationController?.isNavigationBarHidden = true
        self.checkAuthorizationStatusAndStartTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //resetting total steps count(of global variable) from midnight to 0
        // self.upToPreviousSessionStepsfromTodayMidnight = 0
        //self.onStop()
    }
    
    //MARK: INTERFACE BUILDER ACTIONS
    
    @IBAction func postToSteemitBtnAction(_ sender : UIButton) {
        var userCanPost = true
        if let currentUser =  User.current() {
            // userCanPost = abs(currentUser.last_post_date_time_interval) > abs(AppDelegate.todayStartDate().timeIntervalSinceNow)
            let calender = Calendar.autoupdatingCurrent
            userCanPost = !(calender.isDateInToday(currentUser.last_post_date))
        }
        if userCanPost {
            let postToSteemitVC : PostToSteemitVC = PostToSteemitVC.instantiateWithStoryboard(appStoryboard: .SB_Main) as! PostToSteemitVC
            
            self.navigationController?.pushViewController(postToSteemitVC, animated: true)
        } else {
            self.showAlertWith(title: nil, message: Messages.one_post_per_day_error)
        }
    }
    
    @IBAction func viewTrackingHistoryBtnAction(_ sender : UIButton) {
        self.navigationController?.pushViewController(TrackingHistoryVC.instantiateWithStoryboard(appStoryboard: .SB_Main), animated: true)
    }
    
    @IBAction func viewDailyLeaderboardBtnAction(_ sender : UIButton) {
        self.navigationController?.pushViewController(DailyLeaderBoardBVC.instantiateWithStoryboard(appStoryboard: .SB_Main), animated: true)
        
    }
    
    @IBAction func viewWalletBtnAction(_ sender : UIButton) {
        self.navigationController?.pushViewController(WalletVC.instantiateWithStoryboard(appStoryboard: .SB_Main), animated: true)
        
    }
    
    @IBAction func settingsBtnAction(_ sender : UIButton) {
        self.navigationController?.pushViewController(SettingsVC.instantiateWithStoryboard(appStoryboard: .SB_Main), animated: true)
        
    }
    
    //MARK: HELPERS
    
    func setTodayDate() {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let todayDateStr = dateFormatter.string(from: Date())
        self.dateLabel.text  = todayDateStr
    }
    
    @objc func appMovedToBackground() {
        self.timer?.invalidate()
    }
    
    @objc func appMovedToForeground() {
        let calender = Calendar.autoupdatingCurrent
        if !(calender.isDateInToday(startDate)) {
            let yesterdayStartDate = AppDelegate.startDateFor(date: self.startDate)
            if let after24HoursAfteYyesterdayStartDate = Calendar.current.date(
                byAdding: .hour,
                value: 24,
                to: yesterdayStartDate) {
                self.pedometer.queryPedometerData(from: yesterdayStartDate, to: after24HoursAfteYyesterdayStartDate) {
                    [weak self] pedometerData, error in
                    guard let pedometerData = pedometerData, error == nil else { return }
                    DispatchQueue.main.async {
                        print("yesterday total steps : \(pedometerData.numberOfSteps)")
                        self?.saveCurrentStepsCounts(steps: pedometerData.numberOfSteps.intValue, midnightStartDate: yesterdayStartDate)
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.checkAuthorizationStatusAndStartTracking()
            }
        } else {
            self.checkAuthorizationStatusAndStartTracking()
        }
    }
    
    @objc func queryAndUpdateDatafromMidnight() {
        let calender = Calendar.autoupdatingCurrent
        if !(calender.isDateInToday(startDate)) {
            self.showStepsCount(count: 0)
            self.checkAuthorizationStatusAndStartTracking()
        } else {
            self.pedometer.queryPedometerData(from: AppDelegate.todayStartDate(), to: Date()) {
                [weak self] pedometerData, error in
                guard let pedometerData = pedometerData, error == nil else { return }
                DispatchQueue.main.async {
                    print("steps from background tracking : \(pedometerData.numberOfSteps)")
                    let totalSteps = pedometerData.numberOfSteps.intValue
                    self?.showStepsCount(count: totalSteps)
                    self?.saveCurrentStepsCounts(steps: totalSteps, midnightStartDate: AppDelegate.todayStartDate())
                    NotificationCenter.default.post(name: Notification.Name.init(StepsUpdatedNotification), object: nil, userInfo: ["steps" : totalSteps])
                }
            }
        }
    }
    
    //MARK: WEB SERVICES
    
    func getUSerRank() {
        if let user = User.current() {
            let username = user.steemit_username
            APIMaster.getUserRank(username : username,completion: { [weak self] (json) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    if let jsonString = json as? String {
                        if let data = jsonString.data(using: .utf8) {
                            do {
                                if let jsonDict = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String :Any] {
                                    if let user_rank = jsonDict["user_rank"] as? Double {
                                        self?.usernameLabel.text = "@\(username)"
                                        self?.rankLabel.text = "\(user_rank)"
                                    }
                                } else {
                                    print("bad json")
                                }
                            } catch let error as NSError {
                                print(error)
                            }
                        }
                    }
                })
            }) { (error) in
            }
        }
    }
}

extension ActivityTrackingVC {
    
    //on start event handler
    private func checkAuthorizationStatusAndStartTracking() {
        //resetting the start date when wiew appears
        self.startDate = Date()
        checkAuthorizationStatus()
        startUpdating()
    }
    
    //on stop event handler
    private func onStop() {
        stopUpdating()
    }
    
    //stop updating user activity
    private func stopUpdating() {
        activityManager.stopActivityUpdates()
        pedometer.stopUpdates()
        if #available(iOS 10.0, *) {
            pedometer.stopEventUpdates()
        } else {
            pedometer.stopUpdates()
            // Fallback on earlier versions
        }
    }
    
    private func on(error: Error) {
        //handle error
    }
    
    //check for activity authorization Status
    private func checkAuthorizationStatus() {
        if #available(iOS 11.0, *) {
            switch CMMotionActivityManager.authorizationStatus() {
            case CMAuthorizationStatus.denied:
                onStop()
                stepsCountLabel.text = "Not available"
            default:break
            }
        } else {
            //https://stackoverflow.com/questions/23360460/cmmotionactivitymanager-authorizationstatus?lq=1
            // Fallback on earlier versions
            
            /* self.activityManager.queryActivityStarting(from: Date(), to: Date(), to: OperationQueue.main, withHandler: { (activities: [CMMotionActivity]?, error: Error?) -> () in
             if error != nil {
             let errorCode = (error! as NSError).code
             if errorCode == Int(CMErrorMotionActivityNotAuthorized.rawValue) {
             self.onStop()
             self.stepsCountLabel.text = "Not available"
             }
             } else {
             print("Authorized")
             }
             })*/
        }
    }
    
    //track activity types if Motion activity is available on user device
    private func startUpdating() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        } else {
            print("Not available")
        }
        
        if CMPedometer.isStepCountingAvailable() {
            self.startQueryingActivityEveryTwoSecond()
        } else {
            stepsCountLabel.text = "Not available"
        }
    }
    
    //save/update user current steps from today midnight
    private func saveCurrentStepsCounts(steps : Int, midnightStartDate : Date) {
        let allActivities = Activity.all()
        if let activity = allActivities.first(where: {$0.date == midnightStartDate}) {
            // activity.update(date: AppDelegate.todayStartDate(), steps:steps)
            let activtyInfo = [ActivityKeys.id : activity.id, ActivityKeys.date : activity.date, ActivityKeys.steps : steps] as [String : Any]
            activity.upadteWith(info: activtyInfo)
        } else {
            var activityId = allActivities.count + 1
            if allActivities.count > 0 {
                let sortedActivities = allActivities.sorted { (a1, a2) -> Bool in
                    return a1.date > a2.date
                }
                if let lastSavedActivityId = sortedActivities.first?.id {
                    activityId = lastSavedActivityId + 1
                }
            }
            let activtyInfo = [ActivityKeys.id :activityId , ActivityKeys.date : midnightStartDate, ActivityKeys.steps : steps] as [String : Any]

            Activity.saveWith(info: activtyInfo)
        }
    }
    
    //tracks different types of user activity state
    private func startTrackingActivityType() {
        activityManager.startActivityUpdates(to: OperationQueue.main) {
            (activity: CMMotionActivity?) in
            guard let activity = activity else { return }
            DispatchQueue.main.async {
                if activity.walking {
                    print("Walking")
                } else if activity.stationary {
                    print("Stationary")
                } else if activity.running {
                    print("Running")
                } else if activity.automotive {
                    print("Automotive")
                }
            }
        }
    }
    
    //ask pedometer to start updating the user data on regular basis
    private func startQueryingActivityEveryTwoSecond() {
        if #available(iOS 10.0, *) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { (timer) in
                self.queryAndUpdateDatafromMidnight()
            })
        } else {
            // Fallback on earlier versions
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.queryAndUpdateDatafromMidnight), userInfo: nil, repeats: true)
        }
    }
    
    //show the user activity data on UI
    private func showStepsCount(count : Int) {
        //self.stepsCountLabel.text = "Total Activity Today: " + "\(count)"
        //   self.stepsCountLabel.text = "\(count)"
        // stepsCountLabel.countFrom(stepsCountLabel.currentValue(), to: CGFloat(count), withDuration: 3.0)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        self.stepsCountLabel.countFrom(self.stepsCountLabel.currentValue(), to: CGFloat(count), withDuration: 2.0)
        self.stepsCountLabel.formatBlock = {
            (value) in
            return "Total Activity Today: " + (formatter.string(from: NSNumber(value: Int(value))) ?? "")
        }
    }
}




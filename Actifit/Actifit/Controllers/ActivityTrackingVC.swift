//
//  ActivityTrackingVC.swift
//  Actifit
//
//  Created by Hitender kumar on 03/08/18.
//  Copyright © 2018 actifit.io. All rights reserved.
//

import UIKit
import CoreMotion

class ActivityTrackingVC: UIViewController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var stepsCountLabel : UILabel!
    @IBOutlet weak var postToSteemitBtn : UIButton!
    @IBOutlet weak var viewTrackingHistoryBtn : UIButton!
    @IBOutlet weak var viewDailyLeaderboardBtn : UIButton!
    @IBOutlet weak var viewWalletBtn : UIButton!

    //MARK: INSTANCE VARIABLES
    
    let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    var upToPreviousSessionStepsfromTodayMidnight : Int = 0

    var startDate = Date()
    
    //MARK: View Life Cycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postToSteemitBtn.layer.cornerRadius = 4.0
        self.viewTrackingHistoryBtn.layer.cornerRadius = 4.0
        self.viewDailyLeaderboardBtn.layer.cornerRadius = 4.0

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //resetting the start date when wiew appears
        self.startDate = Date()
        self.navigationController?.isNavigationBarHidden = true
        self.setTotalStepsCountsUpFromMidnight()
        self.onStart()
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //resetting total steps count(of global variable) from midnight to 0
        self.upToPreviousSessionStepsfromTodayMidnight = 0
        self.onStop()
    }
    
    //MARK: INTERFACE BUILDER ACTIONS
    
    @IBAction func postToSteemitBtnAction(_ sender : UIButton) {
        var userCanPost = true
        if let currentUser =  User.current() {
            userCanPost = abs(currentUser.last_post_date_time_interval) > abs(AppDelegate.todayStartDate().timeIntervalSinceNow)
        }
        if userCanPost {
            self.navigationController?.pushViewController(PostToSteemitVC.instantiateWithStoryboard(appStoryboard: .SB_Main), animated: true)
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
    
    //MARK : HELPERS
    
    @objc func appMovedToBackground() {
        // self.saveCurrentStepsCounts()
    }
}


extension ActivityTrackingVC {
    
    //start tracking user activity
    private func onStart() {
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
            
            self.activityManager.queryActivityStarting(from: Date(), to: Date(), to: OperationQueue.main, withHandler: { (activities: [CMMotionActivity]?, error: Error?) -> () in
                if error != nil {
                    let errorCode = (error! as NSError).code
                    if errorCode == Int(CMErrorMotionActivityNotAuthorized.rawValue) {
                        self.onStop()
                        self.stepsCountLabel.text = "Not available"
                    }
                } else {
                    print("Authorized")
                }
            })
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
            startCountingSteps()
        } else {
            stepsCountLabel.text = "Not available"
        }
    }
    
    //show locally saved user activity steps count on UI
    private func setTotalStepsCountsUpFromMidnight() {
        if let activity = Activity.all().first(where: {$0.date == AppDelegate.todayStartDate()}) {
            self.showStepsCount(count: activity.steps)
            self.upToPreviousSessionStepsfromTodayMidnight = activity.steps
        }
    }
    
    //save/update user current steps from today midnight
    private func saveCurrentStepsCounts(steps : Int) {
        if let activity = Activity.all().first(where: {$0.date == AppDelegate.todayStartDate()}) {
            activity.update(date: AppDelegate.todayStartDate(), steps:steps)
        } else {
            let activtyInfo = [ActivityKeys.date : AppDelegate.todayStartDate(), ActivityKeys.steps : steps] as [String : Any]
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
    private func startCountingSteps() {
        pedometer.startUpdates(from: self.startDate) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            DispatchQueue.main.async {
                let steps = pedometerData.numberOfSteps.intValue
                print("pedometerData.numberOfSteps.intValue : ", steps)
                let totalStepsCount = (self?.upToPreviousSessionStepsfromTodayMidnight)! + steps
                self?.showStepsCount(count: totalStepsCount)
                self?.saveCurrentStepsCounts(steps: totalStepsCount)
            }
        }
    }
    
    //show the user activity data on UI
    private func showStepsCount(count : Int) {
        self.stepsCountLabel.text = "Total Activity Today: " + "\(count)"
    }
}




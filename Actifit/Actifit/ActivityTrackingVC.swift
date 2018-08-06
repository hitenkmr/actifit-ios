//
//  ActivityTrackingVC.swift
//  Actifit
//
//  Created by Hitender kumar on 03/08/18.
//

import UIKit
import CoreMotion

class ActivityTrackingVC: UIViewController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var activityStateLabel : UILabel!
    @IBOutlet weak var stepsCountLabel : UILabel!
    @IBOutlet weak var postToSteemitBtn : UIButton!
    @IBOutlet weak var viewTrackingHistoryBtn : UIButton!
    @IBOutlet weak var viewDailyLeaderboardBtn : UIButton!
    
    //MARK: INSTANCE VARIABLES
    
    let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    var startDate = Date()
    
    //MARK: View Life Cycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.onStart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.onStop()
    }
    
    //MARK: INTERFACE BUILDER ACTIONS
    
    @IBAction func postToSteemitBtnAction(_ sender : UIButton) {
        
    }
    
    @IBAction func viewTrackingHistoryBtnAction(_ sender : UIButton) {

    }
    
    @IBAction func viewDailyLeaderboardBtnAction(_ sender : UIButton) {
        
    }
    
    //returns current day date from midnight
    func todayStartDate() -> Date {
        //For Start Date
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local
        let dateAtMidnight = calendar.startOfDay(for: Date())
        return dateAtMidnight
    }
}


extension ActivityTrackingVC {
    
    //start tracking user activity
    private func onStart() {
        checkAuthorizationStatus()
        startUpdating()
    }
    
    private func onStop() {
        stopUpdating()
    }
    
    //track activity types if Motion activity is available on user device
    private func startUpdating() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        } else {
            activityStateLabel.text = "Not available"
        }
        
        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        } else {
            stepsCountLabel.text = "Not available"
        }
    }
    
    //check for activity authorization Status
    private func checkAuthorizationStatus() {
        switch CMMotionActivityManager.authorizationStatus() {
        case CMAuthorizationStatus.denied:
            onStop()
            activityStateLabel.text = "Not available"
            stepsCountLabel.text = "Not available"
        default:break
        }
    }
    
    //stop updating user activity
    private func stopUpdating() {
        activityManager.stopActivityUpdates()
        pedometer.stopUpdates()
        pedometer.stopEventUpdates()
    }
    
    private func on(error: Error) {
        //handle error
    }
    
    //tracks different types of user activity state
    private func startTrackingActivityType() {
        activityManager.startActivityUpdates(to: OperationQueue.main) {
            [weak self] (activity: CMMotionActivity?) in
            guard let activity = activity else { return }
            DispatchQueue.main.async {
                if activity.walking {
                    self?.activityStateLabel.text = "Walking"
                } else if activity.stationary {
                    self?.activityStateLabel.text = "Stationary"
                } else if activity.running {
                    self?.activityStateLabel.text = "Running"
                } else if activity.automotive {
                    self?.activityStateLabel.text = "Automotive"
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
                let totalStepsCount = steps
                self?.showStepsCount(count: totalStepsCount)
            }
        }
    }
    
    //show the user activity data on UI
    private func showStepsCount(count : Int) {
        self.stepsCountLabel.text = "Total Activity Today: " + "\(count)"
    }
}




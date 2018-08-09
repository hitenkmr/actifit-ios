//
//  Constants.swift
//  Actifit
//
//  Created by Hitender kumar on 06/07/18.
//  Copyright © 2018 Hitender kumar. All rights reserved.
//

import Foundation
import UIKit
 
//MARK: Singletons

let MainBundle  =  Bundle.main
let Application = UIApplication.shared
let AppDelegate  = Application.delegate as! AFAppDelegate
let DeviceType = AFTDeviceType()
let ISSimulator   = (UIDevice.current.isSimulator)

//MARK: Device

struct MainScreenSize
{
    //  let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    // let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenWidth, ScreenHeight)
    static let SCREEN_MIN_LENGTH = min(ScreenWidth, ScreenHeight)
}

struct AFTDeviceType
{
    let IS_IPHONE_5_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && MainScreenSize.SCREEN_MAX_LENGTH <= 568.0
    let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && MainScreenSize.SCREEN_MAX_LENGTH == 568.0
    let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && MainScreenSize.SCREEN_MAX_LENGTH == 667.0
    let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && MainScreenSize.SCREEN_MAX_LENGTH == 736.0
    let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && MainScreenSize.SCREEN_MAX_LENGTH == 812.0
    let IS_PAD_97INCH = UIDevice.current.userInterfaceIdiom == .pad && MainScreenSize.SCREEN_MAX_LENGTH == 1024
    let IS_PAD_105INCH = UIDevice.current.userInterfaceIdiom == .pad && MainScreenSize.SCREEN_MAX_LENGTH == 1112
    let IS_PAD_129INCH = UIDevice.current.userInterfaceIdiom == .pad && MainScreenSize.SCREEN_MAX_LENGTH == 1366
}

let IsPad   = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
let isiPadPro = IsPad && (UIScreen.main.bounds.size.height == 1024)

//MARK: Device Width & Heights

let CurrentDevice = UIDevice.current
let iOSVersion   = CurrentDevice.systemVersion

let WindowFrame = UIScreen.main.bounds
var ScreenWidth = WindowFrame.size.width
var ScreenHeight = WindowFrame.size.height

let DeviceWidth  = min(ScreenWidth, ScreenHeight)
let DeviceHeight = max(ScreenWidth,ScreenHeight)

let NavBarHeight   =          (20+44)
let SideBarWidth    =         IsPad ? 320 : 240
let MasterWidthForSplitVC =    320

func Format(fmt : String) -> String {
    
    return String.init(fmt)
    
    //use
    // let floatVal: Float = 3.00
    
    //  let str : String =  Format(fmt: "\("this is : ")\(floatVal)")
}

struct Messages {
    static let app_name = "Actifit Fitness Tracker"
    static let sending_post = "Sending your post to the Steem blockchain..."
    static let success_post = "Your post has been successfully submitted to the Steem blockchain"
    static let failed_post = "There was an error submitting your post to the Steem blockchain"
    static let connection_timeout = "Connecting to the Steem node took too long. Please try again."
    static let default_post_title = "My Actifit Report Card:"
    static let error_need_select_one_activity = "You need to select at least one Activity Type to proceed"
    static let fetching_leaderboard = "Updating the leaderboard..."
    static let leader_no_results = "There are no users on the leaderboard now"
    static let leader_error = "An error occurred trying to fetch leaderboard list. Please Try again later."
    static let username_missing = "Please provide a proper existing steemit username"
    static let fetching_user_balance = "Grabbing user balance..."
    static let metric_system = "Metric System"
    static let us_system = "US System"
    static let back_exit_confirmation = "Click BACK button again if you want to exit"
    static let actifit_service_desc = "Actifit Service to keep track of user activity"
    static let activity_today_string = "Actifit Service to keep track of user activity"
    static let actifit_notif_channel = "Total Activity Today:"
    static let actifit_notif_description = "Channel used for sending out notifications of Actifit App"
    static let actifit_channel_ID = "Actifit_Notif_Channel_1"
    static let aggr_back_tracking_on = "ON"
    static let aggr_back_tracking_off = ""
    static let aggr_mode_note = "*Enable this setting if you are facing issues with app tracking your movement while screen is locked. The setting may possibly drain your battery faster."
    static let one_post_per_day_error = "You can only post once per day"
    static let min_word_count_error = "You need to describe your activity in at least "
    static let word_plural_label = "words"
    static let current_workout_going_charity = "Your current activity rewards will go to charity "
    static let current_workout_settings_based = "based on your settings choice. Are you sure you want to proceed? "
    static let steemit_url = "https://www.steemit.com/"
}

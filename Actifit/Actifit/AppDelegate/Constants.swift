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

let MainBundle         =  Bundle.main
let Application        = UIApplication.shared
let AppDelegate        = Application.delegate as! AFAppDelegate
let DeviceType         = AFTDeviceType()
let ISSimulator        = (UIDevice.current.isSimulator)
let APIMaster          = API.sharedInstance

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

//MARK: Colors

extension UIColor{
    class  func UIColorWithRGBA(r: CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
        return UIColor(
            red: CGFloat (r/255.0),
            green: CGFloat (g/255.0),
            blue: CGFloat (b/255.0),
            alpha: CGFloat(a)
        )
    }
}

public let ColorTheme: UIColor = UIColor.UIColorWithRGBA(r: 245, g: 0, b: 35, a: 1.0)

func Format(fmt : String) -> String {
    
    return String.init(fmt)
    
    //use
    // let floatVal: Float = 3.00
    
    //  let str : String =  Format(fmt: "\("this is : ")\(floatVal)")
}



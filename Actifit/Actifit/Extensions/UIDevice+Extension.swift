//
//  UIDevice+Extension.swift
//  Actifit
//
//  Created by Hitender kumar on 10/08/18.
//

import Foundation
import UIKit

extension UIDevice {
    var isSimulator: Bool {
        
        #if arch(i386) || arch(x86_64)
        return true
        #else
        return false
        #endif
        
        //return UIDevice.current.userInterfaceIdiom.rawValue == 0
        
        //not working
        
        //        #if TARGET_IOS_SIMULATOR
        //            return true
        //        #else
        //            return false
        //        #endif
    }
}

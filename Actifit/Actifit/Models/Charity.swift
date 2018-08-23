//
//  Charity.swift
//  Actifit
//
//  Created by Hitender kumar on 21/08/18.
//  Copyright © 2018 actifit.io. All rights reserved.
//

import UIKit

struct CharityKeys {
    static let _id = "_id"
    static let charity_name = "charity_name"
    static let display_name = "display_name"
    static let status = "status"
}
 
class Charity: NSObject {
    
    var _id = ""
    var charity_name = ""
    var display_name = ""
    var status = ""
    
    init(info : [String : Any]) {
        self._id = info.stringValue(forKey: CharityKeys._id)
        self.charity_name = info.stringValue(forKey: CharityKeys.charity_name)
        self.display_name = info.stringValue(forKey: CharityKeys.display_name)
        self.status = info.stringValue(forKey: CharityKeys.status)
    }
}

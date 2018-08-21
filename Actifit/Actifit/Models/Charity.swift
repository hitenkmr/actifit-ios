//
//  Charity.swift
//  Actifit
//
//  Created by Hitender kumar on 21/08/18.
//

import UIKit

struct CharityKeys {
    static let _id = "_id"
    static let charity_name = "charity_name"
    static let display_name = "display_name"
    static let status = "status"
}

/*{"_id":"5b61cfab8abb0e0de08c1d2e","charity_name":"adollaraday","display_name":"A Dollar A Day","status":"enabled"},{"_id":"5b60c8448abb0e0de08c1d2d","charity_name":"mannacurrency","display_name":"Mannacurrency","status":"enabled"},{"_id":"5b62cc468abb0e0de08c1d31","charity_name":"schoolforsdg4","display_name":"School For SDG4","status":"enabled"},{"_id":"5b5ce541fb6fc072a40b684b","charity_name":"steemminna","display_name":"SteemMinna","status":"enabled"},{"_id":"5b630b0fcb27df31f41fcfdb","charity_name":"youarehope","display_name":"YouAreHOPE","status":"enabled"}*/
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

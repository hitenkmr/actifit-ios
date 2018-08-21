//
//  Activity.swift
//  Actifit
//
//  Created by Hitender kumar on 07/08/18.
//  Copyright © 2018 actifit.io. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

let CurrentRealmSchemaVersion : UInt64 = 3

class Activity : Object {
    
    @objc dynamic var date: Date = Date()
    @objc dynamic var steps: Int = 0
    
    class func saveWith(info : [String : Any]) {
        DispatchQueue.global().async {
            // Get new realm and table since we are in a new thread
            autoreleasepool {
                if let realm = AppDelegate.defaultRealm() {
                    realm.beginWrite()
                    realm.create(Activity.self, value: info)
                    try! realm.commitWrite()
                }
            }
        }
    }
    
    //get all saved activities
    class func all() -> [Activity] {
        var contents = [Activity]()
        if let realm = AppDelegate.defaultRealm() {
            let objs = realm.objects(Activity.self)
            objs.forEach({ (content) in
                contents.append(content)
            })
            contents.sort(by: ({ (activity1, activity2) -> Bool in
                return activity1.date > activity2.date
            }))
        }
        return contents
    }
    
    //clear activity history
    class func deleteAll() {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = CurrentRealmSchemaVersion //increase schemaversion if properties changed
        config.migrationBlock = { (migration, oldSchemaVersion) in
            // nothing to do
        }
        do {
            let realm =  try Realm.init(configuration: config)
            let objs = realm.objects(Activity.self)
            realm.beginWrite()
            realm.delete(objs)
            try! realm.commitWrite()
        } catch {
            
        }
    }
    
    //update the activity(steps count)
    func update(date :Date, steps : Int) {
        autoreleasepool {
            if let realm = AppDelegate.defaultRealm() {
                realm.beginWrite()
                self.date = date
                self.steps = steps
                try! realm.commitWrite()
            }
        }
    }
    
}


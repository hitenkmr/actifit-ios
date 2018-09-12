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

let CurrentRealmSchemaVersion : UInt64 = 4

class Activity : Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var date: Date = Date()
    @objc dynamic var steps: Int = 0
    
    override static func primaryKey() -> String? { //primary key needs to be a string or int
        return "id"
    }
    
    class func saveWith(info : [String : Any]) {
        DispatchQueue.global().async {
            // Get new realm and table since we are in a new thread
            autoreleasepool {
                if let realm = AppDelegate.defaultRealm() {
                    realm.beginWrite()
                    //realm.create(Activity.self, value: info)
                    realm.create(Activity.self, value: info, update: false)
                    try! realm.commitWrite()
                }
            }
        }
    }
    
    func upadteWith(info : [String : Any]) {
        DispatchQueue.global().async {
            // Get new realm and table since we are in a new thread
            autoreleasepool {
                if let realm = AppDelegate.defaultRealm() {
                    realm.beginWrite()
                    realm.create(Activity.self, value: info, update: true)
                    try! realm.commitWrite()
                }
            }
        }
    }
    
    //update the activity(steps count)
    /* func update(date :Date, steps : Int) {
     autoreleasepool {
     if let realm = AppDelegate.defaultRealm() {
     realm.beginWrite()
     self.date = date
     self.steps = steps
     try! realm.commitWrite()
     }
     }
     }*/
    
    //get all saved activities
    class func all() -> [Activity] {
        var contents = [Activity]()
        if let realm = AppDelegate.defaultRealm() {
            contents = realm.objects(Activity.self).filter({$0.steps != 0})
            contents.sort(by: ({ (activity1, activity2) -> Bool in
                return activity1.date > activity2.date
            }))
            // contents = self.removeDuplicates(activities: contents)
        }
        return contents
    }
    
    class func removeDuplicates(activities : [Activity]) -> [Activity] {
        /*example
         let activities = [[date : 15/08/2018, steps : 100],
         [date : 15/08/2018, steps : 103],
         [date : 16/08/2018, steps : 345],
         [date : 16/08/2018, steps : 163],
         [date : 17/08/2018, steps : 2345],
         [date : 18/08/2018, steps : 4567],
         [date : 15/08/2018, steps : 2546]]
         
         filtered result will be
         filtered = [[date : 15/08/2018, steps : 2546],
         [date : 16/08/2018, steps : 345],
         [date : 17/08/2018, steps : 2345],
         [date : 18/08/2018, steps : 4567]]
         */
        var filtered = [Activity]()
        var uniquePairs = [Date : Activity]()
        activities.forEach { (activity) in
            if let activity1 = uniquePairs[activity.date] {
                if activity.steps > activity1.steps {
                    uniquePairs[activity.date] = activity
                }
            } else {
                uniquePairs[activity.date] = activity
            }
        }
        uniquePairs.forEach { (arg0) in
            let (_, value) = arg0
            filtered.append(value)
        }
        return filtered
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
    
    func toDictionary() -> [String : Any] {
        return ["date" : self.date, "steps" : self.steps]
    }
}


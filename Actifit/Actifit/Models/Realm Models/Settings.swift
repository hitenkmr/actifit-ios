//
//  Settings.swift
//  Actifit
//
//  Created by Hitender kumar on 21/08/18.
//  Copyright © 2018 actifit.io. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

enum MeasurementSystem : String {
    case metric = "metric"
    case us = "us"
    case none = "none"
}

class Settings: Object {
    
    @objc dynamic var measurementSystem: MeasurementSystem.RawValue = MeasurementSystem.metric.rawValue
    @objc dynamic var isDonatingCharity: Bool = false
    @objc dynamic var charityName: String = ""
    @objc dynamic var charityDisplayName: String = ""

    class func saveWith(info : [String : Any]) {
        DispatchQueue.global().async {
            // Get new realm and table since we are in a new thread
            autoreleasepool {
                if let realm = AppDelegate.defaultRealm() {
                    realm.beginWrite()
                    realm.create(Settings.self, value: info)
                    try! realm.commitWrite()
                }
            }
        }
    }
    
    //get saved settings
    class func current() -> Settings? {
        var user : Settings?
        if let realm = AppDelegate.defaultRealm() {
            let objs = realm.objects(Settings.self)
            user = objs.first
        }
        return user
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
    func update(measurementSystem :MeasurementSystem, isDonatingCharity : Bool, charityName : String, charityDisplayName : String) {
        autoreleasepool {
            if let realm = AppDelegate.defaultRealm() {
                realm.beginWrite()
                self.measurementSystem = measurementSystem.rawValue
                self.isDonatingCharity = isDonatingCharity
                self.charityName = charityName
                self.charityDisplayName = charityDisplayName
                
                try! realm.commitWrite()
            }
        }
    }
    
}

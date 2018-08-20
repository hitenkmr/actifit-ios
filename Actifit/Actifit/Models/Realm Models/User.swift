//
//  User.swift
//  Actifit
//
//  Created by Hitender kumar on 13/08/18.
//  Copyright © 2018 actifit.io. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class User : Object {
    
    @objc dynamic var steemit_username: String = ""
    @objc dynamic var private_posting_key: String = ""
    @objc dynamic var last_post_date_time_interval: TimeInterval = Date().timeIntervalSince1970 //greater value which allows user to compare date

    class var sharedInstance : User {
        return User()
    }
    
    class func saveWith(info : [String : Any]) {
        DispatchQueue.global().async {
            // Get new realm and table since we are in a new thread
            autoreleasepool {
                if let realm = AppDelegate.defaultRealm() {
                    realm.beginWrite()
                    realm.create(User.self, value: info)
                    try! realm.commitWrite()
                }
            }
        }
    }
    
    //get current user(with credentials)
    class func current() -> User? {
        var user : User?
        if let realm = AppDelegate.defaultRealm() {
            let objs = realm.objects(User.self)
           user = objs.first
        }
        return user
    }
    
    //delete current user credentials
    class func deleteCurrentUser() {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = CurrentRealmSchemaVersion //increase schemaversion if properties changed
        config.migrationBlock = { (migration, oldSchemaVersion) in
            // nothing to do
        }
        do {
            let realm =  try Realm.init(configuration: config)
            let objs = realm.objects(User.self)
            realm.beginWrite()
            realm.delete(objs)
            try! realm.commitWrite()
        } catch {
            
        }
    }
    
    //update the credentials
    func updateUser(steemit_username :String, private_posting_key : String, last_post_date_time_interval : TimeInterval) {
        autoreleasepool {
            if let realm = AppDelegate.defaultRealm() {
                realm.beginWrite()
                self.steemit_username = steemit_username
                self.private_posting_key = private_posting_key
                self.last_post_date_time_interval = last_post_date_time_interval
                try! realm.commitWrite()
            }
        }
    }
    
}


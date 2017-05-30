//
//  BaseBuilder.swift
//  Shimi
//
//  Created by Pango-mac on 30/05/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import UIKit
import RealmSwift

class BaseBuilder: NSObject {
    
    let db: Realm
    
    override init() {
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("-test") {
            self.db = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "ui tests"))
        } else {
            self.db = try! Realm()
        }
        super.init()
    }
    
}

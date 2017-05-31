//
//  Entry.swift
//  Shimi
//
//  Created by Pango-mac on 27/05/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import Foundation
import RealmSwift

class Entry: Object {
    dynamic var enter = NSDate()
    dynamic var exit: NSDate? = nil
    
    override static func indexedProperties() -> [String] {
        return ["entered"]
    }
    
    convenience init(enter: NSDate) {
        self.init()
        self.enter = enter
    }

}

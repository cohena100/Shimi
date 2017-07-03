//
//  Settings.swift
//  Shimi
//
//  Created by Pango-mac on 29/06/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import Foundation
import RealmSwift

class Settings: Object {
    dynamic var workHoursADay: TimeInterval = 9 * 60 * 60
    
    convenience init(workHoursADay: TimeInterval) {
        self.init()
        self.workHoursADay = workHoursADay
    }
    
}

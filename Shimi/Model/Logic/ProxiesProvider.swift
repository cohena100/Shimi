//
//  ProxiesProvider.swift
//  Shimi
//
//  Created by Pango-mac on 31/05/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import Foundation
import RealmSwift

protocol ProxiesProvider: class {
    
    var db: Realm { get }
    
}

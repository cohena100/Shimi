//
//  NumberTunerDelegates.swift
//  Shimi
//
//  Created by Pango-mac on 02/06/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import Foundation
import RxSwift

protocol NumberTunerViewModelDelegate: class {
    
}

protocol NumberTunerViewControllerDelegate: class {
    var total: Observable<Int> { get }
}

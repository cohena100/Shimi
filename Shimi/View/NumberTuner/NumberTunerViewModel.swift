//
//  NumberTunerViewModel.swift
//  Shimi
//
//  Created by Pango-mac on 02/06/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import Foundation
import RxSwift

class NumberTunerViewModel: NSObject {
   
    let entriesService: EntriesService
    
    lazy var total: Observable<Int> = {
            return self.entriesService.total.asObservable().map { Int($0) }
    }()
    
    init(entriesService: EntriesService) {
        self.entriesService = entriesService
        super.init()
    }
}

extension NumberTunerViewModel: NumberTunerViewControllerDelegate {}

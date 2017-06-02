//
//  NumberTunerBuilder.swift
//  Shimi
//
//  Created by Pango-mac on 02/06/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import Foundation

class NumberTunerBuilder {
    
    func build() -> NumberTunerViewController {
        let vc = NumberTunerViewController()
        let vm = NumberTunerViewModel()
        vc.vm = vm
        return vc
    }
    
}

//
//  RotatingButtonsViewModel.swift
//  Shimi
//
//  Created by Pango-mac on 20/05/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import Foundation
import RxSwift
import NSObject_Rx

protocol RotatingButtonsViewModelDelegate {
    var isOn: Variable<Bool> { get }
}

class RotatingButtonsViewModel: NSObject {
    
    init(vc: RotatingButtonsViewModelDelegate) {
        super.init()
        vc.isOn.value = true
        vc.isOn.asObservable().skip(1).subscribe(onNext: { (isOn) in
            print(isOn)
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(self.rx_disposeBag)
    }
    
}

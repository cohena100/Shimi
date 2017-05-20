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

protocol RotatingButtonsViewModelDelegate: class {
    var isOn: Variable<Bool> { get }
    var state: RotatingButtonsViewController.State { get set }
}

class RotatingButtonsViewModel: NSObject {
    
    init(vc: RotatingButtonsViewModelDelegate) {
        super.init()
        vc.state = .left
        vc.isOn.asObservable().skip(1).subscribe(onNext: { (isOn) in
            print(isOn)
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(self.rx_disposeBag)
    }
    
}

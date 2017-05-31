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

class RotatingButtonsViewModel: NSObject {
    
    var startingState: RotatingButtonsState = .left
    let isOn = Variable(true)
    let entriesService: EntriesService
    
    init(entriesService: EntriesService, vc: RotatingButtonsViewModelDelegate?) {
        self.entriesService = entriesService
        self.startingState = self.entriesService.isEnterState() ? .left : .right
        vc?.state = self.startingState
        super.init()
        self.isOn.asObservable().skip(1).subscribe(onNext: { (isOn) in
            self.handleEnterOrExit(isOn: isOn)
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(self.rx_disposeBag)
    }

    fileprivate func handleEnterOrExit(isOn: Bool) {
        self.entriesService.entryAction.value = isOn ? EntriesService.EntryAction.enter(NSDate()) : EntriesService.EntryAction.exit(NSDate())
    }
    
}

extension RotatingButtonsViewModel: RotatingButtonsViewControllerDelegate {}


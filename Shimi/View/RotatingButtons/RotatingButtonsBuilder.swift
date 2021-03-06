//
//  RotatingButtonsBuilder.swift
//  Shimi
//
//  Created by Pango-mac on 20/05/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import UIKit

class RotatingButtonsBuilder {
    
    func build() -> RotatingButtonsViewController {
        let enterString = NSLocalizedString("Enter", comment: "enter button title")
        let exitString = NSLocalizedString("Exit", comment: "exit button title")
        let vc = RotatingButtonsViewController(fadedAlpha: 0.2, notFadedAlpha: 1.0, animationDuration: 1.0, enterString: enterString, exitString: exitString)
        let entriesService = Model.sharedInstance.entriesService
        let vm = RotatingButtonsViewModel(entriesService: entriesService, vc: vc)
        vc.vm = vm
        return vc
    }
    
}

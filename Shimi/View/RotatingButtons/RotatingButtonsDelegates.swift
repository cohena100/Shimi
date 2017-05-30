//
//  RotatingButtonsDelegates.swift
//  Shimi
//
//  Created by Pango-mac on 30/05/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import Foundation
import RxSwift

enum RotatingButtonsState {
    case left
    case right
}

protocol RotatingButtonsViewModelDelegate: class {
    var state: RotatingButtonsState { get set }
}

protocol RotatingButtonsViewControllerDelegate: class {
    
    var isOn: Variable<Bool> { get }
    
}

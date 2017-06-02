//
//  NumberTunerViewController.swift
//  Shimi
//
//  Created by Pango-mac on 02/06/2017.
//  Copyright © 2017 TsiliGiliMiliTili. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NumberTunerViewController: UIViewController {
    
    var vm: NumberTunerViewControllerDelegate?
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm?.total.asObservable().map { String($0) }.asDriver(onErrorJustReturn: "").drive(self.numberLabel.rx.text).addDisposableTo(rx_disposeBag)
        setup()
    }
    
    fileprivate func setup() {
        setupNumberLabel()
    }
    
    fileprivate func setupNumberLabel() {
        self.view.addSubview(self.numberLabel)
        self.numberLabel.anchorCenterSuperview()
    }
    
}

// MARK: - Extensions -

extension NumberTunerViewController: NumberTunerViewModelDelegate {}

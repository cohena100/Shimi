//
//  MainViewController.swift
//  Shimi
//
//  Created by Avi Cohen on 01/04/2017.
//  Copyright © 2017 Tsiligilimilitili. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
 
    let mainTitleString: String = {
        let string = NSLocalizedString("Shimi", comment: "main title string")
        return string
    }()
    
    // MARK: - Overloads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setup()
    }
    
    // MARK: - Setups
    
    fileprivate func setup() {
        self.setupRotatingButtonsViewController()
        self.setupNumberTunerViewController()
        self.navigationItem.title = mainTitleString
    }
    
    fileprivate func setupRotatingButtonsViewController() {
        let vc = RotatingButtonsBuilder().build()
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.view.anchorCenterSuperview()
        vc.view.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 100)
        vc.didMove(toParentViewController: self)
    }
    
    fileprivate func setupNumberTunerViewController() {
        let vc = NumberTunerBuilder().build()
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.view.anchorCenterXToSuperview(constant: 0)
        vc.view.anchor(nil, left: nil, bottom: self.view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 64, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        vc.didMove(toParentViewController: self)
    }
}

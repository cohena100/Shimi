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
        view.backgroundColor = .white
        setup()
    }
    
    // MARK: - Setups
    
    fileprivate func setup() {
        setupRotatingButtonsViewController()
        self.navigationItem.title = mainTitleString
    }
    
    fileprivate func setupRotatingButtonsViewController() {
        let contentVC = RotatingButtonsViewController()
        addChildViewController(contentVC)
        contentVC.view.frame = .zero
        view.addSubview(contentVC.view)
        contentVC.view.anchorCenterSuperview()
        contentVC.view.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 100)
        contentVC.didMove(toParentViewController: self)
    }
    
}

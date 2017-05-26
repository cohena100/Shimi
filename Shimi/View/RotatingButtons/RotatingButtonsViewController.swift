//
//  RotatingButtonsViewController.swift
//  Shimi
//
//  Created by Avi Cohen on 25/03/2017.
//  Copyright © 2017 Tsiligilimilitili. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Action

class RotatingButtonsViewController: UIViewController {
    enum State {
        case left
        case right
    }
    var viewModel: RotatingButtonsViewModel!
    let isOn = Variable(true)
    var state: State = .left
    let fadedAlpha: CGFloat
    let notFadedAlpha: CGFloat
    let animationDuration: TimeInterval
    let enterString: String
    let exitString: String
    var leftButtonAnimation: CAAnimationGroup!
    var isAnimating = false
    lazy var leftButton: UIButton = {
        let button = self.createButton()
        self.createTapEvent(forButton: button, isLeftButton: true).subscribe(onNext: { _ in }).addDisposableTo(self.rx_disposeBag)
        button.backgroundColor = .green
        button.setTitle(self.enterString, for: .normal)
        return button
    }()
    lazy var rightButton: UIButton = {
        let button = self.createButton()
        self.createTapEvent(forButton: button, isLeftButton: false).subscribe(onNext: { _ in }).addDisposableTo(self.rx_disposeBag)
        button.backgroundColor = .red
        button.setTitle(self.exitString, for: .normal)
        return button
    }()
    var leftButtonLeftAnchor: NSLayoutConstraint?
    var leftButtonRightAnchor: NSLayoutConstraint?
    var rightButtonLeftAnchor: NSLayoutConstraint?
    var rightButtonRightAnchor: NSLayoutConstraint?
    
    // MARK: - Init
    
    init(fadedAlpha: CGFloat, notFadedAlpha: CGFloat, animationDuration: TimeInterval, enterString: String, exitString: String) {
        self.fadedAlpha = fadedAlpha
        self.notFadedAlpha = notFadedAlpha
        self.animationDuration = animationDuration
        self.enterString = enterString
        self.exitString = exitString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overloads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }
    
    // MARK: - Setups
    
    fileprivate func setup() {
        setupLeftButton()
        setupRightButton()
    }
    
    fileprivate func setupLeftButton() {
        view.addSubview(leftButton)
        leftButton.anchorCenterYToSuperview()
        let anchors = leftButton.anchorWithReturnAnchors(nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        leftButtonLeftAnchor = anchors[0]
        leftButtonRightAnchor = anchors[1]
        if self.state == .left {
            self.leftButton.alpha = self.notFadedAlpha
            leftButtonRightAnchor?.isActive = false
        } else {
            self.leftButton.alpha = self.fadedAlpha
            leftButtonLeftAnchor?.isActive = false
        }
    }
    
    fileprivate func setupRightButton() {
        view.addSubview(rightButton)
        rightButton.anchorCenterYToSuperview()
        let anchors = rightButton.anchorWithReturnAnchors(nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        rightButtonLeftAnchor = anchors[0]
        rightButtonRightAnchor = anchors[1]
        if self.state == .left {
            self.rightButton.alpha = self.fadedAlpha
            rightButtonLeftAnchor?.isActive = false
        } else {
            self.rightButton.alpha = self.notFadedAlpha
            rightButtonRightAnchor?.isActive = false
        }
    }
    
    fileprivate func createButton() -> UIButton {
        let button = UIButton(type:.system)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }
    
    fileprivate func createTapEvent(forButton button: UIButton, isLeftButton: Bool) -> Observable<Void> {
        return button.rx.tap.asObservable().filter { !self.isAnimating }.map { _ -> () in
            self.isAnimating = true
            let isToRight = self.state == .left
            self.leftButtonAnimation = self.generateCompleteButtonAnimation(aView: self.leftButton, isToRight: isToRight)
            }.flatMap { _ -> Observable<Bool> in
                DispatchQueue.main.async {
                    let isToRight = self.state == .left
                    self.leftButton.layer.add(self.leftButtonAnimation, forKey: "leftButtonAnimation")
                    let rightButtonAnimation = self.generateCompleteButtonAnimation(aView: self.rightButton,isToRight: !isToRight)
                    self.rightButton.layer.add(rightButtonAnimation, forKey: "rightButtonAnimation")
                }
                return self.leftButtonAnimation.rx.animationDidStop
            }.map { _ -> () in
                switch self.state {
                case .left:
                    self.leftButtonLeftAnchor?.isActive = false
                    self.leftButtonRightAnchor?.isActive = true
                    self.rightButtonLeftAnchor?.isActive = true
                    self.rightButtonRightAnchor?.isActive = false
                    self.view.bringSubview(toFront: self.leftButton)
                    self.state = .right
                    if isLeftButton {
                        self.isOn.value = true
                    }
                case .right:
                    self.leftButtonLeftAnchor?.isActive = true
                    self.leftButtonRightAnchor?.isActive = false
                    self.rightButtonLeftAnchor?.isActive = false
                    self.rightButtonRightAnchor?.isActive = true
                    self.view.bringSubview(toFront: self.rightButton)
                    self.state = .left
                    if !isLeftButton {
                        self.isOn.value = false
                    }
                }
                self.leftButton.layoutIfNeeded()
                self.rightButton.layoutIfNeeded()
                self.isAnimating = false
        }
    }
    
    // MARK: - Animations
    
    fileprivate func generateCompleteButtonAnimation(aView: UIView, isToRight: Bool) -> CAAnimationGroup {
        let animation = CAAnimationGroup()
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.duration = animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.path =  directionPath(isToRight: isToRight, aView: aView).cgPath
        positionAnimation.duration = animationDuration
        let fadeAnimation = generateFadeAnimation(isToLeft: !isToRight)
        animation.animations = [positionAnimation, fadeAnimation]
        return animation
    }
    
    fileprivate func directionPath(isToRight: Bool, aView: UIView) -> UIBezierPath {
        let path = UIBezierPath()
        let startPoint = aView.center;
        path.move(to: startPoint)
        let directionSign: CGFloat = isToRight ? 1.0 : -1.0
        let pathLength = directionSign * (view.frame.width - aView.frame.width)
        let deltaX = directionSign * abs(pathLength)
        let deltaY = -directionSign * aView.frame.height
        let endPoint = CGPoint(x: startPoint.x + pathLength, y: startPoint.y)
        let cp1 = CGPoint(x: startPoint.x + deltaX, y: startPoint.y + deltaY)
        let cp2 = CGPoint(x: startPoint.x + deltaX, y: startPoint.y)
        path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        return path
    }
    
    fileprivate func generateFadeAnimation(isToLeft: Bool) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.toValue = isToLeft ? notFadedAlpha : fadedAlpha
        return animation
    }
    
}

// MARK: - Extensions -

extension RotatingButtonsViewController: RotatingButtonsViewModelDelegate {
    
}

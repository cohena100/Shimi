//
//  CAAnimationGroup+Rx.swift
//  Shimi
//
//  Created by Avi Cohen on 12/05/2017.
//  Copyright © 2017 Tsiligilimilitili. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxCAAnimationGroupDelegateProxy: DelegateProxy, CAAnimationDelegate, DelegateProxyType {
  class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
    let animationGroup: CAAnimationGroup = object as! CAAnimationGroup
    animationGroup.delegate = delegate as? CAAnimationDelegate
  }
  class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
    let animationGroup: CAAnimationGroup = object as! CAAnimationGroup
    return animationGroup.delegate
  }
}

extension Reactive where Base: CAAnimationGroup {
  var delegate: DelegateProxy {
    return RxCAAnimationGroupDelegateProxy.proxyForObject(base)
  }

  var animationDidStop: Observable<Bool> {
    return delegate.methodInvoked(#selector(CAAnimationDelegate.animationDidStop(_:finished:)))
        .map { finished in
            return finished[1] as! Bool
    }
  }
}

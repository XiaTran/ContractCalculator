//
//  buttonAction.swift
//  ContractCalculator
//
//  Created by Xia Tran on 18/07/2018.
//  Copyright © 2018 Xia Tran. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
  func pulsate() {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.1
    pulse.fromValue = 0.9
    pulse.toValue = 1.0
    //pulse.autoreverses = true
    pulse.repeatCount = 1
    pulse.initialVelocity = 0.5
    pulse.damping = 1.0
    layer.add(pulse, forKey: nil)
  }
}


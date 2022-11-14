//
//  DirectionControlViewModel.swift
//  Snake
//
//  Created by Yu-Chun Hsu on 2022/11/13.
//

import Foundation
import UIKit

struct DirectionControlViewModel {
    var layer: CAShapeLayer
    var moveDirection: MoveDirection
    var baseAffineTransform: CGAffineTransform
    
    init(layer: CAShapeLayer, moveDirection: MoveDirection) {
        self.layer = layer
        self.baseAffineTransform = self.layer.affineTransform()
        self.moveDirection = moveDirection
    }
}

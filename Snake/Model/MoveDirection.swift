//
//  Direction.swift
//  Snake
//
//  Created by Yu-Chun Hsu on 2022/10/20.
//

import Foundation

enum Direction: String {
    case horizontal = "horizontal"
    case vertical = "vertical"
}

enum MoveDirection: String {
    case left = "left"
    case right = "right"
    case top = "top"
    case down = "down"
    
    var direction: Direction {
        switch self {
            case .left, .right:
                return .horizontal
            case .top, .down:
                return .vertical
        }
    }
}

//
//  GameViewSetting.swift
//  Snake
//
//  Created by Yu-Chun Hsu on 2022/10/20.
//

import Foundation
import UIKit

struct GameViewSetting {
    
    var baseWidth: CGFloat = 334
    
    var leftMargin: CGFloat = 10
    var topMargin: CGFloat = 10
    var rightMargin: CGFloat = 10
    var bottomMargin: CGFloat = 10
    var cornerRadius: CGFloat = 5
    
    var gridMargin: CGFloat = 2
    
    var gridHSpace: CGFloat = 3.04
    var gridVSpace: CGFloat = 4
    
    var rowN = 24 // 24
    var colN = 22 // 22
    
    var gridLength: CGFloat = 10
    
    var gridColor = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    var snackColor = #colorLiteral(red: 0.4441065192, green: 0.4441065192, blue: 0.4441065192, alpha: 1)
    var rewardColor = #colorLiteral(red: 0.8528289199, green: 0.2512293458, blue: 0.2144287825, alpha: 1)
}

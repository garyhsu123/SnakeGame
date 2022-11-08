//
//  GameViewModel.swift
//  Snake
//
//  Created by Yu-Chun Hsu on 2022/10/22.
//

import Foundation

class GameViewModel: NSObject {
    
    var eatenFood: Int = 0 {
        didSet {
            if (eatenFood == 0) { return }
            score.value += level.value * 10
            let tmpProgress = eatenFood % countEachLevel
            let tmpLevel = eatenFood / countEachLevel + 1
            if (tmpLevel > level.value) { level.value = tmpLevel }
            if (progress.value != tmpProgress) { progress.value = tmpProgress }
        }
    }
    var progress: Bindable<Int> = Bindable(0)
    var score: Bindable<Int> = Bindable(0)
    var level: Bindable<Int> = Bindable(1)
    var countEachLevel: Int = 4
    var gameOver: Bindable<Bool> = Bindable(false)
}

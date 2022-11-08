//
//  GameScene.swift
//  Snake
//
//  Created by Yu-Chun Hsu on 2022/10/7.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var gameView : GameView?
    private var gameViewModel: GameViewModel?
    
    init(size: CGSize, viewModel: GameViewModel) {
        super.init(size: size)
        self.gameViewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupUI()
    }
    
    func restartGame() {
        gameViewModel?.level.value = 1
        gameViewModel?.progress.value = 0
        gameViewModel?.score.value = 0
        gameView?.restartGame()
    }
    
    func setupUI() {
        
        gameView = GameView(frame: self.frame, setting: GameViewSetting())
        if let gameViewNode = gameView?.node {
            addChild(gameViewNode)
        }
        gameView?.foodEaten.bind(observer: { foodEaten in
            self.gameViewModel?.eatenFood = foodEaten
            
        })
        gameView?.gameOver.bind(observer: { gameOver in
            self.gameViewModel?.gameOver.value = gameOver
        })
        
        
        gameViewModel?.level.bind(observer: { level in
            if level > 1 {
                self.UpdateTimeInterval = 0.1 / (log(Double(level) + 1.2)/log(sqrt(10)))
                print("UpdateTimeInterval = \(self.UpdateTimeInterval)")
            }
        })
        gameView?.setupGrid()
    }
    
    var lastTime = 0.0
    var UpdateTimeInterval = 0.1
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if (currentTime - lastTime > UpdateTimeInterval) {
            lastTime = currentTime
            gameView?.update()
            gameView?.canSnackMoveForward = true
        }
    }
    
    func didTapButton(direction: MoveDirection) {
        gameView?.updateDirection(direction: direction)
    }
}


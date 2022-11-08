//
//  GameView.swift
//  Snake
//
//  Created by Yu-Chun Hsu on 2022/10/9.
//

import UIKit
import SpriteKit

struct GameView {
    var gameOver: Bindable<Bool> = Bindable(false)
    var node: SKShapeNode
    var gridNodes: [SKSpriteNode] = []
    var gameViewSetting: GameViewSetting
    var ratio: CGFloat
    var snack: [vector_int2] = []
    var rewardVec: vector_int2?
    var canSnackMoveForward = false
    
    var foodEaten: Bindable<Int> = Bindable(0)
   
    var curMoveDirection = MoveDirection.down
    
    init(frame: CGRect, setting: GameViewSetting) {
        
        ratio = frame.width / setting.baseWidth
        gameViewSetting = setting
        
        node = SKShapeNode(rect: frame.inset(by: UIEdgeInsets(top: ratio * setting.topMargin, left: ratio * setting.leftMargin, bottom: ratio * setting.bottomMargin, right: ratio * setting.rightMargin)), cornerRadius: ratio * setting.cornerRadius)
        node.fillColor = #colorLiteral(red: 0.9529411765, green: 0.9607843137, blue: 0.968627451, alpha: 1)
    }
    
    mutating func setupGrid() {
        for col in 0..<gameViewSetting.colN {
            for row in 0..<gameViewSetting.rowN {
                let gridNode = SKSpriteNode(color: gameViewSetting.gridColor, size: CGSize(width: 10, height: 10))
                node.addChild(gridNode)
                gridNode.position = self.getPosition(row: row, col: col)
                
                
                self.gridNodes.append(gridNode)
            }
        }
        
        setupSnack()
        insertReward()
    }
    
    private mutating func setupSnack() {
        for bodyVec in snack {
            self.getNode(vector: bodyVec)?.color = gameViewSetting.gridColor
        }
        snack.removeAll()
        snack.append(vector_int2(x: 10, y: 10))
        if let snackHeadVec = snack.first, let snackHeadNode = self.getNode(vector: snackHeadVec) {
            snackHeadNode.color = gameViewSetting.snackColor
        }
    }
    
    private mutating func insertReward() {
        if rewardVec != nil {
            return
        }
        
        rewardVec = vector_int2(x: Int32(Int.random(in: 0..<gameViewSetting.rowN)), y: Int32(Int.random(in: 0..<gameViewSetting.colN)))
        if let rewardNode = self.getNode(vector: rewardVec!) {
            rewardNode.color = gameViewSetting.rewardColor
        }
    }
    
    func getNode(vector: vector_int2) -> SKSpriteNode? {
        if vector.x < 0 || vector.x >= gameViewSetting.rowN || vector.y < 0 || vector.y >= gameViewSetting.colN { return nil }
        let idx = gameViewSetting.rowN*Int(vector.y) + Int(vector.x)
        return gridNodes[Int(idx)]
    }
    
    func getPosition(row: Int, col: Int) -> CGPoint {
        let hDistance = CGFloat(row) * (gameViewSetting.gridHSpace + gameViewSetting.gridLength)
        let x = gameViewSetting.gridMargin + hDistance + 0.5 * gameViewSetting.gridLength
        let vDistance = CGFloat(col) * (gameViewSetting.gridVSpace + gameViewSetting.gridLength)
        let y = gameViewSetting.gridMargin + vDistance + 0.5 * gameViewSetting.gridLength
        return CGPoint(x: node.frame.origin.x + x * ratio, y: node.frame.origin.y + y * ratio)
    }
    
    func getNodeIndex(node: SKSpriteNode) -> Int {
        return getNodeIndex(position: node.position)
    }
    
    func getNodeIndex(position: CGPoint) -> Int {
        // TODO: - Implement
        return 0
    }
    
    mutating func updateDirection(direction: MoveDirection) {
        if (gameOver.value) { return }
        if (curMoveDirection.direction == direction.direction) { return }
        curMoveDirection = direction
        updateSnackPosition()
        canSnackMoveForward = false
    }
    
    mutating func update() {
        if (gameOver.value) { return }
        if (!canSnackMoveForward) { return }
        updateSnackPosition()
    
    }
    
    mutating func restartGame() {
        gameOver.value = false
        foodEaten.value = 0
        setupSnack()
        insertReward()
    }
    
    private mutating func updateSnackPosition() {
        if let oldSnackHeadVec = snack.first {
            let moveDirection = curMoveDirection.vector
            let newSnackHeadVec = vector_int2(x: (oldSnackHeadVec.x + moveDirection.x + Int32(gameViewSetting.rowN))%Int32(gameViewSetting.rowN), y: (oldSnackHeadVec.y + moveDirection.y + Int32(gameViewSetting.colN))%Int32(gameViewSetting.colN))
            
            if (snack.contains(newSnackHeadVec)) {
                print("hit")
                gameOver.value = true
                return
            }
            
            
            getNode(vector: newSnackHeadVec)?.color = gameViewSetting.snackColor
            snack.insert(newSnackHeadVec, at: 0)
        }
        
        if (snack.first == rewardVec) {
            rewardVec = nil
            foodEaten.value += 1
            insertReward()
            return
        }
        
        if let oldSnackTailVec = snack.last {
            getNode(vector: oldSnackTailVec)?.color = gameViewSetting.gridColor
            _ = snack.popLast()
        }
    }
}

extension vector_int2 {
    static func + (left: vector_int2, right: vector_int2) -> vector_int2 {
        return vector_int2(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func == (left: vector_int2, right: vector_int2) -> Bool {
        return left.x == right.x && left.y == right.y
    }
}

extension MoveDirection {
    var vector: vector_int2 {
        switch self {
            case .top:
                return vector_int2(x: 0, y: 1)
            case .down:
                return vector_int2(x: 0, y: -1)
            case .left:
                return vector_int2(x: -1, y: 0)
            case .right:
                return vector_int2(x: 1, y: 0)
        }
    }
}

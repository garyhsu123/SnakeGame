//
//  GameViewController.swift
//  Snake
//
//  Created by Yu-Chun Hsu on 2022/10/7.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    let gameView = SKView(frame: .zero)
    var directionControlButton: DirectionControlButton?
    var gameScene: GameScene?
    let gameViewModel = GameViewModel()
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelView: LevelView!
    @IBOutlet weak var topBarStackView: UIView!
    @IBOutlet weak var scoreViewContainer: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    //    var topBarStackView: UIStackView = {
//        var view = UIStackView()
//        view.axis = .horizontal
//        view.layoutMargins = UIEdgeInsets(top: 0, left: 38, bottom: 0, right: 38)
//        view.isLayoutMarginsRelativeArrangement = true
//        view.backgroundColor = .red
//        return view
//    }()
    
//    var scoreViewContainer: UIView = {
//        var view = UIView()
//        view.layer.borderWidth = 3
//        view.layer.masksToBounds = true
//        view.layer.cornerRadius = 10
//        view.layer.borderColor = #colorLiteral(red: 1, green: 0.7650542855, blue: 0, alpha: 1)
//        return view
//    }()
    
//    var scoreLabel: UILabel = {
//        var view = UILabel(frame: .zero)
//        view.text = "0000"
//        view.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
//        view.textAlignment = .center
//        let attributedString = NSMutableAttributedString(string: view.text!)
//        attributedString.addAttribute(.kern, value: 11.0, range: NSRange(location: 0, length: attributedString.length))
//        view.attributedText = attributedString
//
//        return view
//    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scoreViewContainer.layer.cornerRadius = 10
        scoreViewContainer.layer.borderWidth = 3
        scoreViewContainer.layer.borderColor = #colorLiteral(red: 1, green: 0.7650542855, blue: 0, alpha: 1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.view.addSubview(gameView)
        
        gameView.translatesAutoresizingMaskIntoConstraints = false
        gameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        gameView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 334/390).isActive = true
        gameView.topAnchor.constraint(equalTo: topBarStackView.bottomAnchor, constant: 24).isActive = true
        gameView.widthAnchor.constraint(equalTo: gameView.heightAnchor, multiplier: 334/326).isActive = true
        gameView.widthAnchor.constraint(greaterThanOrEqualTo: self.view.widthAnchor, multiplier: 0).isActive = true
        gameView.layer.cornerRadius = 10
        gameView.layer.masksToBounds = true
        
        directionControlButton = DirectionControlButton(delegate: self)
        self.view.addSubview(directionControlButton!)
        directionControlButton?.translatesAutoresizingMaskIntoConstraints = false
        directionControlButton?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        directionControlButton?.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 236.4 / 390).isActive = true
        directionControlButton?.widthAnchor.constraint(equalTo: directionControlButton!.heightAnchor).isActive = true
        let constraint = directionControlButton?.topAnchor.constraint(equalTo: gameView.bottomAnchor, constant: 40 * UIScreen.main.bounds.width / 390)
        constraint?.priority = .init(rawValue: 999)
        constraint?.isActive = true
        directionControlButton?.topAnchor.constraint(greaterThanOrEqualTo: gameView.bottomAnchor, constant: 10 * self.view.bounds.width / 390).isActive = true
        directionControlButton?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -49.16).isActive = true
        directionControlButton?.layoutIfNeeded()
        directionControlButton?.setup()
        
        gameScene = GameScene(size: CGSize(width: 334, height: 326), viewModel: self.gameViewModel)
        gameScene?.scaleMode = .aspectFill
        gameScene?.backgroundColor = #colorLiteral(red: 1, green: 0.8474411368, blue: 0.4372619987, alpha: 1)
        
        gameView.presentScene(gameScene)
        
        gameView.layer.cornerRadius = 10
        gameView.layer.masksToBounds = true
        gameView.ignoresSiblingOrder = true

        gameView.showsFPS = true
        gameView.showsNodeCount = true
        
        gameViewModel.score.bind { score in
            let attributedString = NSMutableAttributedString(string: String(format: "%04d", score))
            attributedString.addAttribute(.kern, value: 11, range: NSRange(location: 0, length: attributedString.length-1))
            self.scoreLabel.attributedText = attributedString
        }
        gameViewModel.level.bind { level in
            self.levelLabel.text = String(level)
        }
        gameViewModel.progress.bind { progress in
            self.levelView.index = progress
        }
        gameViewModel.gameOver.bind { gameOver in
            if (gameOver) {
                let vc = UIAlertController(title: "Game Over!\nYour score is \(self.gameViewModel.score.value)", message: "", preferredStyle: .alert)
                vc.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
                    self.gameScene?.restartGame()
                }))
                self.present(vc, animated: true)
            }
        }
        levelView.layoutIfNeeded()
        levelView.totalCount = gameViewModel.countEachLevel
       
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: DirectionControlButtonDelegate {
    func didTapDirection(direction: MoveDirection) {
        gameScene?.didTapButton(direction: direction)
    }
}

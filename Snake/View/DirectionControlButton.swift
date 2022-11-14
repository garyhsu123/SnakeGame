//
//  DirectionControlButton.swift
//  Snake
//
//  Created by Yu-Chun Hsu on 2022/10/20.
//

import UIKit

protocol DirectionControlButtonDelegate: AnyObject {
    func didTapDirection(direction: MoveDirection)
}

class DirectionControlButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    weak var delegate: DirectionControlButtonDelegate?
    private var diskLayer: CAShapeLayer!
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    var SCALE: CGFloat {
        get {
            return self.bounds.width / 236.7
        }
    }
    
    var directionControls: [DirectionControlViewModel] = []
//    let leftButton: UIButton = {
//        var view = UIButton(type: .custom)
//        view.setImage(UIImage(named: "LeftBtn"), for: .normal)
//        view.accessibilityIdentifier = MoveDirection.left.rawValue
//        return view
//    }()
//    let rightButton: UIButton = {
//        var view = UIButton(type: .custom)
//        if
//            let leftBtnImage = UIImage(named: "LeftBtn"),
//            let leftBtnCGImage = leftBtnImage.cgImage {
//            view.setImage(UIImage(cgImage: leftBtnCGImage, scale: leftBtnImage.scale, orientation: .upMirrored), for: .normal)
//        }
//        view.accessibilityIdentifier = MoveDirection.right.rawValue
//
//        return view
//    }()
//    let topButton: UIButton = {
//        var view = UIButton(type: .custom)
//        if
//            let leftBtnImage = UIImage(named: "LeftBtn"),
//            let leftBtnCGImage = leftBtnImage.cgImage {
//            view.setImage(UIImage(cgImage: leftBtnCGImage, scale: leftBtnImage.scale, orientation: .right), for: .normal)
//        }
//        view.accessibilityIdentifier = MoveDirection.top.rawValue
//        return view
//    }()
//    let downButton: UIButton = {
//        var view = UIButton(type: .custom)
//        if
//            let leftBtnImage = UIImage(named: "LeftBtn"),
//            let leftBtnCGImage = leftBtnImage.cgImage {
//            view.setImage(UIImage(cgImage: leftBtnCGImage, scale: leftBtnImage.scale, orientation: .rightMirrored), for: .normal)
//        }
//        view.accessibilityIdentifier = MoveDirection.down.rawValue
//        return view
//    }()
    
    convenience init(delegate: DirectionControlButtonDelegate? = nil) {
        self.init(frame: .zero)
        self.delegate = delegate
        
    }
    
    func setup() {
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func triangleShapeLayer() -> CAShapeLayer {
        let triangleShapeLayer = CAShapeLayer()
        let trianglePath = UIBezierPath()
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let length = 42.0 * SCALE
        trianglePath.move(to: CGPoint(x: center.x - length/2, y: center.y))
        trianglePath.addLine(to: CGPoint(x: center.x, y: center.y - length/2 * sqrt(3)))
        trianglePath.addLine(to: CGPoint(x: center.x + length/2, y: center.y))
        trianglePath.close()

        var transform: CGAffineTransform = .identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: Double.pi  / 4)
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        
        trianglePath.apply(transform)
        triangleShapeLayer.path = trianglePath.cgPath
        triangleShapeLayer.fillColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        return triangleShapeLayer
    }
    
    func buttonShapeLayer() -> CAShapeLayer {
        let buttonShapeLayer = CAShapeLayer()
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        let space: CGFloat = 2.5
        let R: CGFloat = self.bounds.width / 2
        let r: CGFloat = 20
        
        
        let path = UIBezierPath()
        let degreeR = asin(space/R)
        let degreer = asin(space/r)
        
        path.move(to: CGPoint(x: center.x + space, y: center.y - r * cos(degreer)))
        path.addArc(withCenter: center, radius: R, startAngle: -Double.pi/2 + degreeR, endAngle: -degreeR, clockwise: true)
        path.addLine(to: CGPoint(x: center.x + r * cos(degreer), y: center.y - space))
        path.addArc(withCenter: center, radius: r, startAngle: -degreer, endAngle: -Double.pi / 2 + degreer, clockwise: false)
        path.close()
        buttonShapeLayer.path = path.cgPath
        
        let triangleShaperLayer = triangleShapeLayer()
        triangleShaperLayer.setAffineTransform(CGAffineTransformTranslate(.identity, 30 * sqrt(2) * SCALE , -30 * sqrt(2) * SCALE))
        buttonShapeLayer.addSublayer(triangleShaperLayer)
        buttonShapeLayer.shadowColor = UIColor.red.cgColor
        buttonShapeLayer.shadowRadius = 10.0
        return buttonShapeLayer
    }
    
    func setupUI() {
        
        
        self.isMultipleTouchEnabled = true
        
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        let rightBtn = buttonShapeLayer()
        rightBtn.fillColor = #colorLiteral(red: 1, green: 0.8474411368, blue: 0.4372619987, alpha: 1)
        
        var rightBtnAffineTransform: CGAffineTransform = .identity
        rightBtnAffineTransform = rightBtnAffineTransform.translatedBy(x: center.x, y: center.y)
        rightBtnAffineTransform = rightBtnAffineTransform.rotated(by: Double.pi  / 4)
        rightBtnAffineTransform = rightBtnAffineTransform.translatedBy(x: -center.x, y: -center.y)
        rightBtn.setAffineTransform(rightBtnAffineTransform)
        
        directionControls.append(DirectionControlViewModel(layer: rightBtn, moveDirection: .right))
        layer.addSublayer(rightBtn)
        
        let topBtn = buttonShapeLayer()
        topBtn.fillColor = #colorLiteral(red: 1, green: 0.8474411368, blue: 0.4372619987, alpha: 1)

        var topBtnAffineTransform: CGAffineTransform = .identity
        topBtnAffineTransform = topBtnAffineTransform.translatedBy(x: center.x, y: center.y)
        topBtnAffineTransform = topBtnAffineTransform.rotated(by: -Double.pi  / 4)
        topBtnAffineTransform = topBtnAffineTransform.translatedBy(x: -center.x, y: -center.y)
        topBtn.setAffineTransform(topBtnAffineTransform)

        directionControls.append(DirectionControlViewModel(layer: topBtn, moveDirection: .top))
        layer.addSublayer(topBtn)

        let downBtn = buttonShapeLayer()
        downBtn.fillColor = #colorLiteral(red: 1, green: 0.8474411368, blue: 0.4372619987, alpha: 1)

        var downBtnAffineTransform: CGAffineTransform = .identity
        downBtnAffineTransform = downBtnAffineTransform.translatedBy(x: center.x, y: center.y)
        downBtnAffineTransform = downBtnAffineTransform.rotated(by: 3 * Double.pi  / 4)
        downBtnAffineTransform = downBtnAffineTransform.translatedBy(x: -center.x, y: -center.y)
        downBtn.setAffineTransform(downBtnAffineTransform)

        directionControls.append(DirectionControlViewModel(layer: downBtn, moveDirection: .down))
        layer.addSublayer(downBtn)

        let leftBtn = buttonShapeLayer()
        leftBtn.fillColor = #colorLiteral(red: 1, green: 0.8474411368, blue: 0.4372619987, alpha: 1)

        var leftBtnAffineTransform: CGAffineTransform = .identity
        leftBtnAffineTransform = leftBtnAffineTransform.translatedBy(x: center.x, y: center.y)
        leftBtnAffineTransform = leftBtnAffineTransform.rotated(by: -3 * Double.pi  / 4)
        leftBtnAffineTransform = leftBtnAffineTransform.translatedBy(x: -center.x, y: -center.y)
        leftBtn.setAffineTransform(leftBtnAffineTransform)

        directionControls.append(DirectionControlViewModel(layer: leftBtn, moveDirection: .left))
        layer.addSublayer(leftBtn)
    }
    
   
    @objc func didTapButton(_ sender: UIControl) {
        guard let delegate = delegate else {
            return
        }
        
        if let accessibilityIdentifier = sender.accessibilityIdentifier, let direction = MoveDirection(rawValue: accessibilityIdentifier) {
            delegate.didTapDirection(direction: direction)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        for btn in directionControls {
            if let hit = btn.layer.path?.contains(location, transform: CGAffineTransformInvert(btn.baseAffineTransform)), hit {
                var transform = btn.baseAffineTransform
                transform = CGAffineTransformTranslate(transform, self.bounds.midX, self.bounds.midY)
                transform = CGAffineTransformScale(transform, 0.95, 0.95)
                transform = CGAffineTransformTranslate(transform, -self.bounds.midX, -self.bounds.midY)
                btn.layer.setAffineTransform(transform)
                btn.layer.fillColor = #colorLiteral(red: 1, green: 0.9062994086, blue: 0.6543702384, alpha: 1)
                feedbackGenerator.impactOccurred()
                delegate?.didTapDirection(direction: btn.moveDirection)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        for btn in directionControls {
            if let hit = btn.layer.path?.contains(location, transform: CGAffineTransformInvert(btn.baseAffineTransform)), hit {
                let transform: CATransform3D = CATransform3DMakeAffineTransform((btn.baseAffineTransform))
                btn.layer.transform = transform
                btn.layer.fillColor = #colorLiteral(red: 1, green: 0.8474411368, blue: 0.4372619987, alpha: 1)
            }
        }
    }
}

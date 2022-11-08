//
//  LevelView.swift
//  Snake
//
//  Created by Yu-Chun Hsu on 2022/11/5.
//

import UIKit

@IBDesignable
class LevelView: UIView {
    
    var totalCount: Int = 5 {
        didSet {
            setupBar()
        }
    }
    var index: Int = 0 {
        didSet {
            setNeedsDisplay()
            setupBar()
        }
    }
    
    var progressWidth: CGFloat {
        get {
            return self.bounds.width - 2 * borderWidth
        }
    }
    var borderColor: UIColor = #colorLiteral(red: 0.6823529412, green: 0.7725490196, blue: 1, alpha: 1)
    var fillColor: UIColor = #colorLiteral(red: 0.3647058824, green: 0.5450980392, blue: 1, alpha: 1)
    var bgColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.24)
    var lineColor: UIColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5568627451, alpha: 1)
    var lineWidth = 1.0
    var borderWidth = 2.0
    
    var stickViews: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
        setupBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
        setupBar()
    }
    
    func verticalStickView() -> UIView {
        let container = UIView()
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        let space = 2.0
        path.move(to: CGPoint(x: 0, y: space + borderWidth))
        path.addLine(to: CGPoint(x: 0, y:self.bounds.height - borderWidth - space))
//        print(CGPoint(x: 0, y:self.bounds.height - 2 * borderWidth - 2 * space))
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = lineColor.cgColor
        container.layer.addSublayer(shapeLayer)
        return container
    }
    
    func customInit() {
        self.frame = CGRectInset(self.frame, -borderWidth, -borderWidth)
    }
    
    func setupBar() {
        
        self.backgroundColor = bgColor
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = 6
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
        
        stickViews.removeAll()
        self.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        for i in 1..<totalCount {
            let view = verticalStickView()
            stickViews.append(view)
            self.addSubview(view)
            view.frame = CGRect(x: borderWidth + CGFloat(i) * progressWidth / CGFloat(totalCount) , y: 0, width: 0, height: 0)
        }
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: borderWidth, y: self.bounds.midY))
        path.addLine(to: CGPoint(x: borderWidth + CGFloat(index) * progressWidth / CGFloat(totalCount) , y: self.bounds.midY))
        path.lineWidth = self.bounds.height
        fillColor.setStroke()
        path.stroke()
    }
    
  
}

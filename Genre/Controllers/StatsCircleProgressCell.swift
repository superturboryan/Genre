//
//  StatsCircleProgressCell.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-11-16.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class StatsCircleProgressCell: UICollectionViewCell {
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    var displayLink: CADisplayLink?

    let animationDuration: Double = 1.5
    let animationStart: Date = Date()
    
    var valueToDisplay: Double?
    
    @IBOutlet weak var statDescriptionLabel: UILabel!
    @IBOutlet weak var statsPercentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.statsPercentLabel.text = "\(0)"
        
        self.addDefaultShadow()
        
        self.layer.cornerRadius = 10
    }

    func positionCircularProgressBar(){
        
        let cellSquareWidth = self.frame.size.width
        
        let cellCenter = CGPoint(x: cellSquareWidth/2, y: cellSquareWidth/2)
        
        let circularPath = UIBezierPath(arcCenter: cellCenter, radius: cellSquareWidth*0.38, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = cellSquareWidth == cellSquareSize ? 12 : 30
        shapeLayer.fillColor = UIColor(white: 1, alpha: 0.2).cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 1.0

        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = cellSquareWidth == cellSquareSize ? 12 : 30
        trackLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(trackLayer)
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func animateProgressCircle() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")

        basicAnimation.fromValue = 0
        
        basicAnimation.toValue =  (valueToDisplay! / 100.0) * 0.795

        basicAnimation.duration = animationDuration
        
        basicAnimation.fillMode = .forwards
        
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation,forKey: "basicStroke")
    }
    
    func removeCircularProgressBar() {
        self.shapeLayer.removeFromSuperlayer()
        self.trackLayer.removeFromSuperlayer()
    }
    
    func setupPercentLabelAnimation() {
    
        displayLink = CADisplayLink(target: self, selector: #selector(animatePercentLabel))
        displayLink?.add(to: .main, forMode: RunLoop.Mode.default)
    }
    
    @objc func animatePercentLabel() {
        
        let start: Double = 0
        let end = valueToDisplay!
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStart)
       
       if elapsedTime > animationDuration {
        self.statsPercentLabel.text = "\(Int(end))%"
        self.displayLink!.invalidate()
        self.displayLink = nil
       }
       else {
        let percentComplete = elapsedTime / animationDuration
        let value = Int(start + percentComplete * (Double(end) - start))
        statsPercentLabel.text = "\(value)%"
       }
        
    }
    
}

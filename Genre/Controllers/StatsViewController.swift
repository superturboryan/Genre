//
//  StatsViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-05.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    let options = UserDefaults.standard
    
    let shapeLayer = CAShapeLayer()
    
    @IBOutlet weak var statsLabel: UILabel!
    
    var displayLink: CADisplayLink?
    
    var overallCorrectPercentage: Double = 0
    
    var animationDuration: Double = 1.5
    
    var animationStart: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateStats()
        
        setupCircularProgressBar()
        
        setupView()
        
        animateProgressCircleToPercent(value: overallCorrectPercentage)
        
        setupOverallPercentLabelAnimation()
    }
    
    func setupView() {
        
        
    }
    
    func calculateStats() {
        
        overallCorrectPercentage = round((Double(options.integer(forKey: "correctCount")) / (Double(options.integer(forKey: "correctCount")) + Double(options.integer(forKey: "incorrectCount")))) * 100)
        
    }
 
    func setupCircularProgressBar(){
        
        // Progress Layer
        
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        if #available(iOS 13.0, *) {
            shapeLayer.strokeColor = UIColor.systemIndigo.cgColor
        } else {
            shapeLayer.strokeColor = UIColor.red.cgColor
        }
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 1.0

        // Track Layer
        
        let trackLayer = CAShapeLayer()
        
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        
        trackLayer.lineWidth = 18
        trackLayer.fillColor = UIColor.clear.cgColor
        
        view.layer.addSublayer(trackLayer)
        
        view.layer.addSublayer(shapeLayer)
        
    }
    
    func animateProgressCircleToPercent(value: Double) {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.fromValue = 0
        
        basicAnimation.toValue =  (value / 100) * 0.795

        basicAnimation.duration = animationDuration
        
        basicAnimation.fillMode = .forwards
        
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation,forKey: "basicStroke")
    }
    
    func setupOverallPercentLabelAnimation() {
    
        displayLink = CADisplayLink(target: self, selector: #selector(animateDisplayLink))
        displayLink?.add(to: .main, forMode: RunLoop.Mode.default)
    }
    
    @objc func animateDisplayLink() {
        
        let start: Double = 0
        let end = overallCorrectPercentage
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStart)
       
       if elapsedTime > animationDuration {
        self.statsLabel.text = "\(end) %"
            displayLink!.invalidate()
            displayLink = nil
        
       }
       else {
        let percentage = elapsedTime / animationDuration
           let value = round(start + percentage * (end - start))
            statsLabel.text = "\(value) %"
       }
        
    }


}
//
//  StatsViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-05.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit


class StatsViewControllerOld: UIViewController {

    var delegate: MainMenuDelegate?
    let shapeLayer = CAShapeLayer()
    @IBOutlet weak var statsLabel: UILabel!
    var displayLink: CADisplayLink?
    var overallCorrectPercentage: Double = 0
    var animationDuration: Double = 1.5
    var animationStart: Date = Date()
    
    @IBOutlet var chartView: MacawChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) { overrideUserInterfaceStyle = .light }
        
        calculateStats()
        
        setupCircularProgressBar()
        
        animateProgressCircleToPercent(value: overallCorrectPercentage)
        
        setupOverallPercentLabelAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MacawChartView.reloadSessions()
        MacawChartView.playAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            self.delegate?.shrinkMenu()
            self.delegate?.showButtons()
            self.navigationController?.popViewController(animated: false)
    }
    
    func setupView() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        chartView.contentMode = .scaleAspectFit
        
        MacawChartView.playAnimation()
    }
    
    func calculateStats() {
        overallCorrectPercentage = StatsManager.sharedInstance.getOverallCorrectPercentage()
    }
 
    func setupCircularProgressBar(){
        
        // Progress Layer
        
        var labelCenter = statsLabel.center
        
        labelCenter = CGPoint.init(x: labelCenter.x, y: labelCenter.y+20)
        
        let circularPath = UIBezierPath(arcCenter: labelCenter, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
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
        self.statsLabel.text = "\(lround(end)) %"
            displayLink!.invalidate()
            displayLink = nil
        
       }
       else {
        let percentage = elapsedTime / animationDuration
           let value = lround(start + percentage * (end - start))
            statsLabel.text = "\(value) %"
       }
        
    }


}

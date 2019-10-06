//
//  StatsViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-05.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    @IBOutlet weak var percentCorrectLabel: UILabel!
    
    let options = UserDefaults.standard
    
    let shapeLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCircularProgressBar()
        
        setupView()
        
        let percentCorrect = (Double(options.integer(forKey: "correctCount")) / (Double(options.integer(forKey: "correctCount")) + Double(options.integer(forKey: "incorrectCount")))) * 100
        
        setProgressToPercent(value: percentCorrect)

        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        
        let percentCorrect: Double = round((Double(options.integer(forKey: "correctCount")) / (Double(options.integer(forKey: "correctCount")) + Double(options.integer(forKey: "incorrectCount")))) * 100)
        
        percentCorrectLabel.text = "\(percentCorrect) %"
        
    }
 
    func addCircularProgressBar(){
        
        // Progress Layer
        
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        if #available(iOS 13.0, *) {
            shapeLayer.strokeColor = UIColor.systemIndigo.cgColor
        } else {
            shapeLayer.strokeColor = UIColor.red.cgColor
        }
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 1.0

        // Track Layer
        
        let trackLayer = CAShapeLayer()
        
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        
        view.layer.addSublayer(trackLayer)
        
        view.layer.addSublayer(shapeLayer)
        
    }
    
    func setProgressToPercent(value: Double) {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.fromValue = 0
        
        basicAnimation.toValue =  (value / 100) * 0.795

        basicAnimation.duration = 3
        
        basicAnimation.fillMode = .forwards
        
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation,forKey: "basicStroke")
    }
    
    @objc func handleTap() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 3
        
        basicAnimation.fillMode = .forwards
        
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation,forKey: "basicStroke")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  MacawChartView.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-21.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import Foundation
import Macaw

struct testSession {
    var correctCount: Int
    var incorrectCount: Int
}

class MacawChartView: MacawView {
    
    static let lastFiveSessions = SessionManager.sharedInstance.getLastFiveSessions()
    
    static let maxLineHeight:Int = 180
    
    static let maxValue = 100
    
    static let lineWidth: Double = 275
    
    static let dataDivisor = Double(maxValue) / Double(maxLineHeight)
    
    static let adjustedData: [Double] = lastFiveSessions.map({
        (((Double($0.correctCount) / Double($0.correctCount + $0.incorrectCount))) / dataDivisor) * 100
    })
    
    static var animations: [Animation] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(node: MacawChartView.createChart(), coder: aDecoder)
        
        backgroundColor = .clear
    }
    
    static func createChart() -> Group {
        
        var items: [Node] = addYAxisItems() + addXAxisItems()
        
        items.append(createBars())
        
        return Group(contents: items, place: .identity)
    }
    
    
    static func createDummyData() -> [testSession] {
        
        let one = testSession(correctCount: 7, incorrectCount: 3);
        let two = testSession(correctCount: 3, incorrectCount: 7);
        let three = testSession(correctCount: 7, incorrectCount: 4);
        let four = testSession(correctCount: 2, incorrectCount: 8);
        let five = testSession(correctCount: 6, incorrectCount: 4);
        
        return [one, two, three, four, five]
    }
    
    static func addYAxisItems() -> [Node] {
        
        let maxLines = 4
        let lineInterval = Int(maxValue/maxLines)
        
        let yAxisHeight: Double = 200
        let lineSpacing: Double = 30.0
        
        var newNodes: [Node] = []
        
        for i in 1...maxLines {
            
            let y = yAxisHeight - (Double(i) * lineSpacing)
            
            let valueLine = Line(x1: -5, y1: y, x2: lineWidth, y2: y).stroke(fill: Color.white.with(a: 0.5))
            
            let valueText = Text(text: "\(i*lineInterval)", align: .max, baseline: .mid, place: .move(dx: -10, dy: y))
            valueText.fill = Color.white
            
            newNodes.append(valueLine)
            newNodes.append(valueText)
        }
        
        let yAxis = Line(x1: 0, y1: 0, x2: 0, y2: yAxisHeight).stroke(fill: Color.white.with(a: 0.75))
        
        newNodes.append(yAxis)
        
        return newNodes
    }
    
    static func addXAxisItems() -> [Node] {
        
        let chartBaseY: Double = 200
        
        var newNodes: [Node] = []
        
        for i in 1...adjustedData.count {
            
            let x = (Double(i) * 50)
            
            let valueText = Text(text: "\(i)", align: .max, baseline: .mid, place: .move(dx: x, dy: chartBaseY + 15) )
            
            valueText.fill = Color.white
            
            newNodes.append(valueText)
        }
        
        let xAxis = Line(x1: 0, y1: chartBaseY, x2: lineWidth, y2: chartBaseY).stroke(fill: Color.white.with(a: 0.75))
        
        newNodes.append(xAxis)
        
        return newNodes
    }

    
    static func createBars() -> Group {
        
        let fill = LinearGradient(degree: 90, from: Color.white.with(a: 0.3), to: Color.white)
        
        let items = adjustedData.map { _ in Group() }
        
        animations = items.enumerated().map { (i: Int, item: Group) in
            
            item.contentsVar.animation(delay: Double(i)*0.1) { t in
                
                let height = adjustedData[i]*t
                
                let rect = Rect(x: Double(i) * 50 + 25, y: 200 - height, w: 30, h: height)
                
                return [rect.fill(with: fill)]
            }
        }
        
        return items.group()
    }
    
    static func playAnimation() {
        
        animations.combine().play()
    }
    
    
}

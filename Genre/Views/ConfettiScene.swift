//
//  ConfettiScene.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-11-16.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit
import SpriteKit

class ConfettiScene: SKScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.scene?.backgroundColor = .clear
    }
    
    func setupConfetti(withPositon position:CGPoint) {
        
        let emitter = SKEmitterNode(fileNamed: "ConfettiExplosion")
        
        let colorArray:[UIColor] = [
            UIColor(red: 204.0/255.0, green: 23.0/255.0, blue: 71.0/255.0, alpha: 1),
            UIColor(red: 255.0/255.0, green: 164.0/255.0, blue: 2.0/255.0, alpha: 1),
            UIColor(red: 7.0/255.0, green: 202.0/255.0, blue: 196.0, alpha: 1),
            UIColor(red: 222.0/255.0, green: 93.0/255.0, blue: 0.0/255.0, alpha: 1),
            UIColor(red: 195.0/255.0, green: 94.0/255.0, blue: 232.0/255.0, alpha: 1),
            .white
        ]
        emitter?.particleColorSequence = nil
        emitter?.particleColorBlendFactor = 1.0
        
        emitter?.position = position
        
        self.addChild(emitter!)
        
        let action = SKAction.run({
            [unowned self] in
            let random = Int(arc4random_uniform(UInt32(colorArray.count)))

            emitter?.particleColor = colorArray[random];
        })

        let wait = SKAction.wait(forDuration: 0.1)

        self.run(SKAction.repeatForever(SKAction.sequence([action,wait])))
    }

}

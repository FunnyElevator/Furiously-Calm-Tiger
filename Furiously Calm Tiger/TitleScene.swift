//
//  TitleScene.swift
//  Furiously Calm Tiger
//
//  Created by Fabian on 16.05.16.
//  Copyright © 2016 Fabian. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene {
    var startButton: SKSpriteNode?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        startButton = self.childNodeWithName("StartButton") as? SKSpriteNode
        startButton!.alpha = 0.0
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "StartButton" {
                print("Start button touched")
                if let actionPressed = SKAction(named: "StartButtonPressed") {
                    startButton!.runAction(actionPressed, completion: {
                        let transition = SKTransition.fadeWithDuration(1.0)
                        
                        let nextScene = GameScene(fileNamed: "GameScene")
                        nextScene!.scaleMode = .AspectFill
                        
                        self.scene?.view?.presentScene(nextScene!, transition: transition)
                    })
                }
            } else {
                // remove previous emitters? after 2s?
                
                // sprakle emitter for Other Touches
                let particlePath:NSString = NSBundle.mainBundle().pathForResource("Sparkles", ofType: "sks")!
                let sparklesEmmiter = NSKeyedUnarchiver.unarchiveObjectWithFile(particlePath as String) as! SKEmitterNode
                sparklesEmmiter.position = location
                sparklesEmmiter.name = "sparkEmmitter"
                sparklesEmmiter.zPosition = 400
                //sparkEmmiter.targetNode = self
                self.addChild(sparklesEmmiter)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}


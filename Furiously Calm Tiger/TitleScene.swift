//
//  TitleScene.swift
//  Furiously Calm Tiger
//
//  Created by Fabian on 16.05.16.
//  Copyright © 2016 Fabian. All rights reserved.
//

import SpriteKit
import Flurry_iOS_SDK

class TitleScene: SKScene {
    var startButton: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        startButton = self.childNode(withName: "StartButton") as? SKSpriteNode
        startButton!.alpha = 0.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        super.touchesBegan(touches, with: event)
        
        //remove previous partcile emitters
        for child in self.children {
            if child.name == "sparkEmmitter" {
                child.removeFromParent()
            }
        }
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "StartButton" {
                print("Start button touched")
                if let actionPressed = SKAction(named: "StartButtonPressed") {
                    startButton!.run(actionPressed, completion: {
                        let transition = SKTransition.fade(withDuration: 1.0)
                        
                        let nextScene = GameScene(fileNamed: "GameScene")
                        nextScene!.scaleMode = .aspectFill
                        
                        // Analytics
                        Flurry.logEvent("GameSession_Started");
                        Flurry.logEvent("GameSession_Complete", withParameters: nil, timed: true);
                        // Finished in GameScene: restartGame()
  
                        
                        self.scene?.view?.presentScene(nextScene!, transition: transition)
                    })
                }
            } else {                
                // sprakle emitter for Other Touches
                let particlePath:NSString = Bundle.main.path(forResource: "Sparkles", ofType: "sks")! as NSString
                let sparklesEmmiter = NSKeyedUnarchiver.unarchiveObject(withFile: particlePath as String) as! SKEmitterNode
                sparklesEmmiter.position = location
                sparklesEmmiter.name = "sparkEmmitter"
                sparklesEmmiter.zPosition = 400
                //sparkEmmiter.targetNode = self
                self.addChild(sparklesEmmiter)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}


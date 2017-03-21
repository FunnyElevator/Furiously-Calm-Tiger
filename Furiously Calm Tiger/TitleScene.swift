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
    var startSparkle: SKEmitterNode?
    
    var infoButton: SKSpriteNode?
    var infoScreen: SKNode?
    var infoIsVisible: Bool = false
  
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        startButton = self.childNode(withName: "StartButton") as? SKSpriteNode
        startButton!.alpha = 0.0
        
        infoButton = self.childNode(withName: "InfoButton") as? SKSpriteNode
        infoScreen = self.childNode(withName: "InfoScreen")
        
        //Add sparkle emitters to COLOR circles
        let roundParticleThinPath:NSString = Bundle.main.path(forResource: "RoundParticle2", ofType: "sks")! as NSString
        startSparkle = (NSKeyedUnarchiver.unarchiveObject(withFile: roundParticleThinPath as String) as! SKEmitterNode)
        startSparkle!.position = CGPoint(x: 0.0, y: 0.0)
        startSparkle!.name = "color1Sparkle"
        startSparkle!.zPosition = -1
        startSparkle?.xScale = 0.7
        startSparkle?.yScale = 0.7
        startButton?.addChild(startSparkle!)
        
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
            let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
            
            if infoIsVisible {
                infoButton?.run(fadeInAction)
                infoScreen?.run(fadeOutAction)
                startButton?.run(fadeInAction, completion: { 
                    self.infoIsVisible = false
                })
            }
            if touchedNode.name == "StartButton" {
                print("Start button touched")
                if let actionPressed = SKAction(named: "StartButtonPressed") {
                    startButton!.run(actionPressed, completion: {
                        // Analytics
                        Flurry.logEvent("GameSession_Started");
                        Flurry.logEvent("GameSession_Complete", withParameters: nil, timed: true);
                        // Finished in GameScene: restartGame()
                        
                        //let transition = SKTransition.fade(withDuration: 1.0) //old fade
                        let transition = SKTransition.push(with: SKTransitionDirection.up, duration: 2)
                        let nextScene = GameScene(fileNamed: "GameScene")
                        // resize scene to fit iphone aspect ratio (1024x576 -> 16:9)
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            nextScene?.size.height = 576.0
                        }
                        nextScene!.scaleMode = .aspectFill
                        self.scene?.view?.presentScene(nextScene!, transition: transition)
                    })
                }
            } else if touchedNode.name == "InfoButton" {
                infoIsVisible = true
                infoButton?.run(fadeOutAction)
                infoScreen?.run(fadeInAction)
                startButton?.run(fadeOutAction)
                
            } else {
                // create touch circle effect
                let roundparticlePath:NSString = Bundle.main.path(forResource: "RoundParticle", ofType: "sks")! as NSString
                let sparkEmmiter = NSKeyedUnarchiver.unarchiveObject(withFile: roundparticlePath as String) as! SKEmitterNode
                sparkEmmiter.position = location
                sparkEmmiter.name = "sparkEmmitter"
                sparkEmmiter.zPosition = 400
                self.addChild(sparkEmmiter)
                
                /* sprakle emitter for Other Touches
                let particlePath:NSString = Bundle.main.path(forResource: "Sparkles", ofType: "sks")! as NSString
                let sparklesEmmiter = NSKeyedUnarchiver.unarchiveObject(withFile: particlePath as String) as! SKEmitterNode
                sparklesEmmiter.position = location
                sparklesEmmiter.name = "sparkEmmitter"
                sparklesEmmiter.zPosition = 400
                //sparkEmmiter.targetNode = self
                self.addChild(sparklesEmmiter) */
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}


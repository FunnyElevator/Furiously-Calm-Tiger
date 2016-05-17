//
//  TitleScene.swift
//  Furiously Calm Tiger
//
//  Created by Fabian on 16.05.16.
//  Copyright © 2016 Fabian. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        super.touchesBegan(touches, withEvent: event)
        
        if let location = touches.first?.locationInNode(self) {
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "StartButton" {
                print("Start button touched")
                let transition = SKTransition.fadeWithDuration(1.0)
                
                let nextScene = GameScene(fileNamed: "GameScene")
                nextScene!.scaleMode = .AspectFill
                
                scene?.view?.presentScene(nextScene!, transition: transition)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}


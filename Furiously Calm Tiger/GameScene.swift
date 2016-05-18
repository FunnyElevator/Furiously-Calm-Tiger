//
//  GameScene.swift
//  Furiously Calm Tiger
//
//  Created by Fabian on 02.05.16.
//  Copyright (c) 2016 Fabian. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var colorFieldLeft: SKSpriteNode?
    var colorFieldRight: SKSpriteNode?
    var colorLineLeft: SKSpriteNode?
    var colorLineRight: SKSpriteNode?
    
    var emojiButton: SKSpriteNode?
    
    var emojis = [SKTexture]()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        colorFieldLeft = self.childNodeWithName("colorFieldLeft") as? SKSpriteNode
        colorFieldRight = self.childNodeWithName("colorFieldRight") as? SKSpriteNode
        colorLineLeft = self.childNodeWithName("colorLineLeft") as? SKSpriteNode
        colorLineRight = self.childNodeWithName("colorLineRight") as? SKSpriteNode
        
        /* Prepare Interface elements */
        colorFieldLeft?.alpha = 0.0
        colorFieldRight?.alpha = 0.0
        colorLineLeft?.alpha = 0.0
        colorLineRight?.alpha = 0.0
        
        
        emojis.append(SKTexture(imageNamed: "emoji-happy-1f61b"))
        emojis.append(SKTexture(imageNamed: "emoji-happy-flushed-1f60a"))
        emojis.append(SKTexture(imageNamed: "emoji-happy-love-1f60d"))
        emojis.append(SKTexture(imageNamed: "emoji-happy-mouth-1f600"))
        emojis.append(SKTexture(imageNamed: "emoji-happy-tongue-1f61c"))
        emojis.append(SKTexture(imageNamed: "emoji-happy-twinker-1f609"))
        emojis.append(SKTexture(imageNamed: "emoji-happy-upside-1f643"))
        emojis.append(SKTexture(imageNamed: "emoji-hushed-1f62f"))
        emojis.append(SKTexture(imageNamed: "emoji-kiss-1f617"))
        emojis.append(SKTexture(imageNamed: "emoji-neutral-1f610"))
        emojis.append(SKTexture(imageNamed: "emoji-neutral-1f636"))
        emojis.append(SKTexture(imageNamed: "emoji-neutral-1f644"))
        emojis.append(SKTexture(imageNamed: "emoji-positive-1f642"))
        emojis.append(SKTexture(imageNamed: "emoji-sad-1f61f"))
        emojis.append(SKTexture(imageNamed: "emoji-sad-1f626"))
        emojis.append(SKTexture(imageNamed: "emoji-sad-cry-1f622"))
        emojis.append(SKTexture(imageNamed: "emoji-sad-cry-1f625"))
        emojis.append(SKTexture(imageNamed: "emoji-sad-flushed-1f623"))
        emojis.append(SKTexture(imageNamed: "emoji-sad-mouth-1f62b"))
        emojis.append(SKTexture(imageNamed: "emoji-sad-teeth-1f62c"))
        emojis.append(SKTexture(imageNamed: "emoji-unhappy-sick-1f915"))
        emojis.append(SKTexture(imageNamed: "emoji-xx-1f635"))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            sprite.zPosition = 200
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
        
    }
    
    func setupEmojiSelect() {
        //
        // Randomly select a character
        let rand = Int(arc4random_uniform(UInt32(emojis.count)))
        let emojiTexture = emojis[rand] as SKTexture
        
        emojiButton!.texture = emojiTexture
        // Optionally, resize the sprite
        emojiButton!.size = emojiTexture.size()
    }
}

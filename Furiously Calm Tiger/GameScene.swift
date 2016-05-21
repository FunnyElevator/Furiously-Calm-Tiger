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
    var lastEmoji:Int = 0
    var colors = [UIColor]()
    var lastColor: Int = 0
    
    var currentGameMode: Int = 1
            /*  1: preEmoji
                2: EmojiSelect
                3: ColorSelect   */
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        colorFieldLeft = self.childNodeWithName("colorFieldLeft") as? SKSpriteNode
        colorFieldRight = self.childNodeWithName("colorFieldRight") as? SKSpriteNode
        colorLineLeft = self.childNodeWithName("colorLineLeft") as? SKSpriteNode
        colorLineRight = self.childNodeWithName("colorLineRight") as? SKSpriteNode
        
        /* Prepare Interface elements */
        resetColorAreas()
        
        // Setup Emoji Textures
        emojis = [
            SKTexture(imageNamed: "emoji-happy-1f61b"),
            SKTexture(imageNamed: "emoji-happy-flushed-1f60a"),
            SKTexture(imageNamed: "emoji-happy-love-1f60d"),
            SKTexture(imageNamed: "emoji-happy-mouth-1f600"),
            SKTexture(imageNamed: "emoji-happy-tongue-1f61c"),
            SKTexture(imageNamed: "emoji-happy-twinker-1f609"),
            SKTexture(imageNamed: "emoji-happy-upside-1f643"),
            SKTexture(imageNamed: "emoji-hushed-1f62f"),
            SKTexture(imageNamed: "emoji-kiss-1f617"),
            SKTexture(imageNamed: "emoji-neutral-1f610"),
            SKTexture(imageNamed: "emoji-neutral-1f636"),
            SKTexture(imageNamed: "emoji-neutral-1f644"),
            SKTexture(imageNamed: "emoji-positive-1f642"),
            SKTexture(imageNamed: "emoji-sad-1f61f"),
            SKTexture(imageNamed: "emoji-sad-1f626"),
            SKTexture(imageNamed: "emoji-sad-cry-1f622"),
            SKTexture(imageNamed: "emoji-sad-cry-1f625"),
            SKTexture(imageNamed: "emoji-sad-flushed-1f623"),
            SKTexture(imageNamed: "emoji-sad-mouth-1f62b"),
            SKTexture(imageNamed: "emoji-sad-teeth-1f62c"),
            SKTexture(imageNamed: "emoji-unhappy-sick-1f915"),
            SKTexture(imageNamed: "emoji-xx-1f635")
        ]
        
        // Setup Colors
        colors = [
            UIColor(red: 210/255, green: 77/255,  blue: 87/255,  alpha: 1.0),
            UIColor(red: 217/255, green: 30/255,  blue: 24/255,  alpha: 1.0),
            UIColor(red: 150/255, green: 40/255,  blue: 27/255,  alpha: 1.0),
            UIColor(red: 220/255, green: 198/255, blue: 224/255, alpha: 1.0),
            UIColor(red: 103/255, green: 65/255,  blue: 114/255, alpha: 1.0),
            UIColor(red: 68/255,  green: 108/255, blue: 179/255, alpha: 1.0),
            UIColor(red: 210/255, green: 77/255,  blue: 87/255,  alpha: 1.0),
            UIColor(red: 228/255, green: 241/255, blue: 254/255, alpha: 1.0),
            UIColor(red: 65/255,  green: 131/255, blue: 215/255, alpha: 1.0),
            UIColor(red: 89/255,  green: 171/255, blue: 227/255, alpha: 1.0),
            UIColor(red: 129/255, green: 207/255, blue: 224/255, alpha: 1.0),
            UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1.0)
        ]
        
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
            //setupColorSelect()
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
    
    func setupColorSelect() {
        let fadeInAction = SKAction.fadeInWithDuration(0.5)
        
        let leftColor = getRandomValue(colors.count, lastValue: lastColor)
        lastColor = leftColor
        colorFieldLeft?.color = colors[leftColor]
        
        let rightColor = getRandomValue(colors.count, lastValue: lastColor)
        lastColor = rightColor
        colorFieldRight?.color = colors[rightColor]
        
        colorLineLeft?.runAction(fadeInAction)
        colorLineRight?.runAction(fadeInAction)
        colorFieldLeft?.runAction(fadeInAction)
        colorFieldRight?.runAction(fadeInAction)
        
    }
    
    
    func getRandomValue(fromRange: Int, lastValue: Int) -> Int {
        var randomIndex = Int(arc4random_uniform(UInt32(fromRange)))
        while (randomIndex == lastValue) {
            randomIndex = Int(arc4random_uniform(UInt32(fromRange)))
        }
        return randomIndex
    }
    
    func resetColorAreas() {
        colorFieldLeft?.alpha = 0.0
        colorFieldRight?.alpha = 0.0
        colorLineLeft?.alpha = 0.0
        colorLineRight?.alpha = 0.0
    }
    
}

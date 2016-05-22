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
    
    
    var emojiButton1: SKSpriteNode?
    var emojiButton2: SKSpriteNode?
    
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
        
        // Connect UI Elements from the Editor
        colorFieldLeft = self.childNodeWithName("colorFieldLeft") as? SKSpriteNode
        colorFieldRight = self.childNodeWithName("colorFieldRight") as? SKSpriteNode
        colorLineLeft = self.childNodeWithName("colorLineLeft") as? SKSpriteNode
        colorLineRight = self.childNodeWithName("colorLineRight") as? SKSpriteNode
        emojiButton1 = self.childNodeWithName("emojiButton1") as? SKSpriteNode
        emojiButton2 = self.childNodeWithName("emojiButton2") as? SKSpriteNode
        
        /* Prepare Interface elements */
        resetColorAreas()
        emojiButton1?.alpha = 0.0
        emojiButton2?.alpha = 0.0
        
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
         // SKTexture(imageNamed: "emoji-neutral-1f636"), // used as placeholder
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
            
            // Demo action
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            sprite.zPosition = 200
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            sprite.runAction(SKAction.repeatActionForever(action))
            self.addChild(sprite)
            
            
            let touchedNode = nodeAtPoint(location)
            
            if (currentGameMode == 1) {
                currentGameMode += 1
                
                setupEmojiSelect()
            } else if (currentGameMode == 2) {
                if (touchedNode.name == "emojiButton1") {
                    performEmojiSelect(1)
                    print("Button 1")
                } else if (touchedNode.name == "emojiButton2") {
                    performEmojiSelect(2)
                    print("Button 1")
                }
            } else if (currentGameMode >= 3) {
                
                setupColorSelect()
            }
            
            
            let roundparticlePath:NSString = NSBundle.mainBundle().pathForResource("RoundParticle", ofType: "sks")!
            let sparkEmmiter = NSKeyedUnarchiver.unarchiveObjectWithFile(roundparticlePath as String) as! SKEmitterNode
            
            sparkEmmiter.position = location
            sparkEmmiter.name = "sparkEmmitter"
            sparkEmmiter.zPosition = 1000
            //sparkEmmiter.targetNode = self
            self.addChild(sparkEmmiter)
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
        
    }
    
    func setupEmojiSelect() {
        let fadeInAction = SKAction.fadeInWithDuration(0.5)
        
        // Randomly select a character
        let leftEmoji = getRandomValue(emojis.count, lastValue: lastEmoji)
        emojiButton1?.texture = emojis[leftEmoji] as SKTexture
        lastEmoji = leftEmoji
        
        let rightEmoji = getRandomValue(emojis.count, lastValue: lastEmoji)
        emojiButton2?.texture = emojis[rightEmoji] as SKTexture
        lastEmoji = rightEmoji
        
        // Optionally, resize the sprite
        //emojiButton1!.size = emojiTexture.size()
    
        emojiButton1?.runAction(fadeInAction)
        emojiButton2?.runAction(fadeInAction)
    }
    
    func performEmojiSelect(buttonNr: Int) {
        let fadeOut = SKAction.fadeOutWithDuration(0.5)
        let moveToCenter = SKAction.moveToX(512, duration: 0.8)
        
        setupColorSelect()
        currentGameMode += 1
        
        if buttonNr == 1 {
            emojiButton2?.runAction(fadeOut)
            emojiButton1?.runAction(moveToCenter)
        } else if buttonNr == 2 {
            emojiButton1?.runAction(fadeOut)
            emojiButton2?.runAction(moveToCenter)
        }
    }
    
    
    func setupColorSelect() {
        let fadeInAction = SKAction.fadeInWithDuration(0.5)
        
        let leftColor = getRandomValue(colors.count, lastValue: lastColor)
        colorFieldLeft?.color = colors[leftColor]
        lastColor = leftColor
        
        let rightColor = getRandomValue(colors.count, lastValue: lastColor)
        colorFieldRight?.color = colors[rightColor]
        lastColor = rightColor
        
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

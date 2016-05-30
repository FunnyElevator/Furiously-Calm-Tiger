//
//  GameScene.swift
//  Furiously Calm Tiger
//
//  Created by Fabian on 02.05.16.
//  Copyright (c) 2016 Fabian. All rights reserved.
//

import SpriteKit
import GameAnalytics

class GameScene: SKScene {
    var colorFieldLeft: SKSpriteNode?
    var colorFieldRight: SKSpriteNode?
    var colorLineLeft: SKSpriteNode?
    var colorLineRight: SKSpriteNode?
    
    var emojiButton1: SKSpriteNode?
    var emojiButton2: SKSpriteNode?
    var smallCirclesL: SKNode?
    var smallCirclesR: SKNode?
    
    
    // for logging
    var lastEmoji1Number: Int = 0
    var lastEmoji2Number: Int = 0
    
    var emoji1Angry: Bool = false
    var emoji1Tired: Bool = false
    var emoji1Twike: Bool = false
    var emoji2Angry: Bool = false
    var emoji2Tired: Bool = false
    var emoji2Twike: Bool = false
    
    
    var emojis = [SKTexture]()
    var lastEmoji:Int = 0
    var colors = [UIColor]()
    var lastColor: Int = 0
    
    var theTiger: SKNode?
    var tigerSnooze: SKNode?
    var tigerMouthOpen: SKSpriteNode?
    var tigerMouthClosed1: SKSpriteNode?
    var tigerMouthClosed2: SKSpriteNode?
    
    var emoji1Sparkle: SKEmitterNode?
    var emoji2Sparkle: SKEmitterNode?
    
    var tigerMoodAngryIndex: Int = 0
    var tigerMoodTiredIndex: Int = 0
    var tigerMoodTwinkeIndex: Bool = false
    
    var blockInteraction: Bool = false
    
    var currentGameMode: Int = 1
            /*  1: preEmoji
                2: EmojiSelect
                3: ColorSelect
                4: TigerReaction -> jump to Mode 2   */
    var roundsPlayed: Int = 0
            /*  If gameRound greather than maxRounds reset game */
    let maxRounds:Int = 3

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Connect UI Elements from the Editor
        colorFieldLeft  = self.childNodeWithName("colorFieldLeft")  as? SKSpriteNode
        colorFieldRight = self.childNodeWithName("colorFieldRight") as? SKSpriteNode
        colorLineLeft  = self.childNodeWithName("colorLineLeft")  as? SKSpriteNode
        colorLineRight = self.childNodeWithName("colorLineRight") as? SKSpriteNode
        emojiButton1 = self.childNodeWithName("emojiButton1") as? SKSpriteNode
        emojiButton2 = self.childNodeWithName("emojiButton2") as? SKSpriteNode
        smallCirclesL = self.childNodeWithName("smallCirclesL")
        smallCirclesR = self.childNodeWithName("smallCirclesR")
        
        theTiger = self.childNodeWithName("Tiger")
        tigerSnooze = self.childNodeWithName("TigerSnooze")
        tigerMouthOpen = theTiger!.childNodeWithName("TigerMouthOpen") as? SKSpriteNode // TigerBody ??
        //tigerMouthClosed1 = tiger!.childNodeWithName("TigerMouthClosed1") as? SKSpriteNode                // ##### Fill x
        //tigerMouthClosed2 = tiger!.childNodeWithName("TigerMouthClosed2") as? SKSpriteNode                // ##### Fill x
        theTiger!.enumerateChildNodesWithName("*") { (node, stop) in
            print(node.name)
        }
        
        
        /* Prepare Interface elements */
        resetColorAreas()
        emojiButton1?.alpha = 0.0
        emojiButton2?.alpha = 0.0
        smallCirclesL?.hidden = true
        smallCirclesR?.hidden = true
        //tigerMouthOpen?.alpha = 0.0                           didn't work...
        //tigerMouthClosed1?.alpha = 0.0
        
        //Add sparkle emitters to Emoji Icons
        let roundparticlePath:NSString = NSBundle.mainBundle().pathForResource("RoundParticle2", ofType: "sks")!
        emoji1Sparkle = (NSKeyedUnarchiver.unarchiveObjectWithFile(roundparticlePath as String) as! SKEmitterNode)
        emoji1Sparkle!.position = CGPointMake(0.0, 0.0)
        emoji1Sparkle!.name = "emoji1Sparkle"
        emoji1Sparkle!.zPosition = 0
        emojiButton1?.addChild(emoji1Sparkle!)
        
        emoji2Sparkle = (NSKeyedUnarchiver.unarchiveObjectWithFile(roundparticlePath as String) as! SKEmitterNode)
        emoji2Sparkle!.position = CGPointMake(0.0, 0.0)
        emoji2Sparkle!.name = "emoji2Sparkle"
        emoji2Sparkle!.zPosition = 0
        emojiButton2?.addChild(emoji2Sparkle!)
        
        
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
            UIColor(red: 217/255, green: 30/255,  blue: 24/255,  alpha: 1.0),
            UIColor(red: 103/255, green: 65/255,  blue: 114/255, alpha: 1.0),
            
            UIColor(red: 210/255, green: 77/255,  blue: 87/255,  alpha: 1.0),
            UIColor(red: 129/255, green: 207/255, blue: 224/255, alpha: 1.0),
            
            UIColor(red: 52/255,  green: 152/255, blue: 219/255, alpha: 1.0),
            UIColor(red: 25/255,  green: 181/255, blue: 254/255, alpha: 1.0),
            
            UIColor(red: 58/255,  green: 83/255,  blue: 155/255, alpha: 1.0),
            UIColor(red: 37/255,  green: 116/255, blue: 169/255, alpha: 1.0),
            //5
            UIColor(red: 31/255,  green: 58/255,  blue: 147/255, alpha: 1.0),
            UIColor(red: 137/255, green: 196/255, blue: 244/255, alpha: 1.0),
            
            UIColor(red: 135/255, green: 211/255, blue: 124/255, alpha: 1.0),
            UIColor(red: 38/255,  green: 166/255, blue: 91/255,  alpha: 1.0),
            
            UIColor(red: 27/255,  green: 163/255, blue: 156/255, alpha: 1.0),
            UIColor(red: 134/255, green: 226/255, blue: 213/255, alpha: 1.0),
            
            UIColor(red: 46/255,  green: 204/255, blue: 113/255, alpha: 1.0),
            UIColor(red: 3/255,   green: 166/255, blue: 120/255, alpha: 1.0),
            
            UIColor(red: 42/255,  green: 187/255, blue: 155/255, alpha: 1.0),
            UIColor(red: 30/255,  green: 130/255, blue: 76/255,  alpha: 1.0),
            
            UIColor(red: 232/255, green: 126/255, blue: 4/255,   alpha: 1.0),
            UIColor(red: 242/255, green: 120/255, blue: 75/255,  alpha: 1.0),
            
            UIColor(red: 211/255, green: 84/255,  blue: 0/255,   alpha: 1.0),
            UIColor(red: 249/255, green: 191/255, blue: 59/255,  alpha: 1.0)
        ]
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            /* Demo action
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            sprite.zPosition = 200
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            sprite.runAction(SKAction.repeatActionForever(action))
            self.addChild(sprite)*/
            
            
            let touchedNode = nodeAtPoint(location)
            if (blockInteraction == false) {
                if (currentGameMode == 1) {
                    currentGameMode += 1
                    
                    setupEmojiSelect()
                } else if (currentGameMode == 2) {
                    if (touchedNode.name == "emojiButton1") {
                        performEmojiSelect(1)
                        print("Emoji 1")
                         GameAnalytics.setCustomDimension01("emojiLeft")
                    } else if (touchedNode.name == "emojiButton2") {
                        performEmojiSelect(2)
                        print("Emoji 2")
                    }
                } else if (currentGameMode == 3) {
                    if (touchedNode.name == "colorFieldLeft") {
                        //performColorSelect(1)
                        print("Color 1")
                    } else if (touchedNode.name == "colorFieldRight") {
                        //performColorSelect(2)
                        print("Color 2")
                    }
                }
                
                
                //remove previous partcile emitters
                
                // create touch circle effect
                let roundparticlePath:NSString = NSBundle.mainBundle().pathForResource("RoundParticle", ofType: "sks")!
                let sparkEmmiter = NSKeyedUnarchiver.unarchiveObjectWithFile(roundparticlePath as String) as! SKEmitterNode
                sparkEmmiter.position = location
                sparkEmmiter.name = "sparkEmmitter"
                sparkEmmiter.zPosition = 400
                //sparkEmmiter.targetNode = self
                self.addChild(sparkEmmiter)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch : AnyObject in touches {
            
            let location : CGPoint = touch.locationInNode(self)
            let nodes : Array = self.nodesAtPoint(location)
            for node in nodes {
                // Select a node by it's name
                if (currentGameMode == 3) {
                    if (node.name == "emojiButton1" || node.name == "emojiButton2") {
                        node.position = location
                        
                        if (location.y > 187) {
                            let moveToCenter = SKAction.moveTo(CGPointMake(512, 88), duration: 0.5)
                            moveToCenter.timingMode = SKActionTimingMode.EaseOut
                            node.runAction(moveToCenter)
                        } else {
                            if (location.x < 287) {
                                performColorSelect(1)
                            } else if (location.x > 737) {
                                performColorSelect(2)
                            }
                            
                        }
                    }
                }
            }
        } 
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch : AnyObject in touches {
            
            let location : CGPoint = touch.locationInNode(self)
            let nodes : Array = self.nodesAtPoint(location)
            for node in nodes {
                if (currentGameMode == 3 && blockInteraction == false) {
                    if (node.name == "emojiButton1" || node.name == "emojiButton2") {
                        if (node.position.x == 512 && node.position.y == 88){
                        } else {
                            let moveToCenter = SKAction.moveTo(CGPointMake(512, 88), duration: 0.4)
                            moveToCenter.timingMode = SKActionTimingMode.EaseOut
                            node.runAction(moveToCenter)
                        }
                    
                    }
                }
            }
        }
    }

   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func setupEmojiSelect() {
        let fadeInAction = SKAction.fadeInWithDuration(0.5)
        
        // Randomly select a character
        let leftEmoji = getRandomValue(emojis.count, lastValue: lastEmoji)
        lastEmoji1Number = leftEmoji
        emojiButton1?.texture = emojis[leftEmoji] as SKTexture
        self.setupEmojiMood(leftEmoji, leftOrRight: 1)
        lastEmoji = leftEmoji
        
        let rightEmoji = getRandomValue(emojis.count, lastValue: lastEmoji)
        emojiButton2?.texture = emojis[rightEmoji] as SKTexture
        self.setupEmojiMood(rightEmoji, leftOrRight: 2)
        lastEmoji = rightEmoji
        lastEmoji2Number = rightEmoji
        
        // Optionally, resize the sprite
        // emojiButton1!.size = emojiTexture.size()
    
        emojiButton1?.runAction(fadeInAction)
        emojiButton2?.runAction(fadeInAction)
    }
    
    func performEmojiSelect(buttonNr: Int) {
        let fadeOut = SKAction.fadeOutWithDuration(0.5)
        let moveToCenter = SKAction.moveToX(512, duration: 0.8)
        blockInteraction = true
        
        var emojiSelectedAngry = false
        var emojiSelectedTired = false
        var emojiSelectedTwinker = false
        
        if buttonNr == 1 {
            emojiButton2?.runAction(fadeOut)
            emojiButton1?.runAction(moveToCenter, completion: { 
                self.smallCirclesL?.hidden = false
                self.smallCirclesR?.hidden = false
            })
            emojiSelectedTired = emoji1Tired
            emojiSelectedAngry = emoji1Angry
            emojiSelectedTwinker = emoji1Twike
            GameAnalytics.addProgressionEventWithProgressionStatus(GAProgressionStatusStart, progression01: "world01", progression02: "level01", progression03: "")
        } else if buttonNr == 2 {
            emojiButton1?.runAction(fadeOut)
            emojiButton2?.runAction(moveToCenter, completion: {
                self.smallCirclesL?.hidden = false
                self.smallCirclesR?.hidden = false
                GameAnalytics.addProgressionEventWithProgressionStatus(GAProgressionStatusStart, progression01: "world01", progression02: "level02", progression03: "")
            })
            emojiSelectedTired = emoji2Tired
            emojiSelectedAngry = emoji2Angry
            emojiSelectedTwinker = emoji2Twike
        }
        if (emojiSelectedAngry == true) {
            tigerMoodAngryIndex += 1
        }
        if (emojiSelectedTired == true) {
            tigerMoodTiredIndex += 1
        }
        
        tigerMoodTwinkeIndex = emojiSelectedTwinker
        
        setupColorSelect()
        currentGameMode += 1
    }
    
    func performColorSelect(buttonNr: Int) {
        currentGameMode += 1
        blockInteraction = true
        var colorButtonCenter:CGFloat = 0.0
        let fadeOutAction = SKAction.fadeOutWithDuration(0.5)
        self.smallCirclesL?.hidden = true
        self.smallCirclesR?.hidden = true
        
        
        //
        emojiButton1?.childNodeWithName("emoji1Sparkle")?.hidden = true
        emojiButton2?.childNodeWithName("emoji2Sparkle")?.hidden = true
        //
        
        print("Run color function")
        if (buttonNr == 1) {
            colorButtonCenter = (colorFieldLeft?.position.x)!
            self.colorFieldRight?.runAction(fadeOutAction)
            self.colorLineRight?.runAction(fadeOutAction)
        } else if (buttonNr == 2) {
            colorButtonCenter = (colorFieldRight?.position.x)!
            self.colorFieldLeft?.runAction(fadeOutAction)
            self.colorLineLeft?.runAction(fadeOutAction)
        }
        let moveAction = SKAction.moveTo(CGPointMake(colorButtonCenter, 88) , duration: 0.5)
        moveAction.timingMode = SKActionTimingMode.EaseInEaseOut
        
        if (emojiButton2?.alpha == 0.0) {
            emojiButton1?.runAction(moveAction, completion: {
                self.perfomTigerReaction()
            })
        } else if (emojiButton1?.alpha == 0.0) {
            emojiButton2?.runAction(moveAction, completion: {
                self.perfomTigerReaction()
            })
        }
    }
    
    func perfomTigerReaction() {
        // remove UI elemnts
        let fadeOutAction = SKAction.fadeOutWithDuration(0.5)
        let waitAction = SKAction.waitForDuration(2)
        roundsPlayed += 1
        self.runAction(waitAction, completion: {
            self.emojiButton1?.runAction(fadeOutAction)
            self.emojiButton2?.runAction(fadeOutAction, completion: {
                self.emojiButton1?.position = CGPointMake(442, 88)
                self.emojiButton2?.position = CGPointMake(582, 88)
                self.colorFieldRight?.runAction(fadeOutAction)
                self.colorFieldLeft?.runAction(fadeOutAction)
                self.colorLineLeft?.runAction(fadeOutAction)
                self.colorLineRight?.runAction(fadeOutAction)
                self.blockInteraction = false
                self.emojiButton1?.childNodeWithName("emoji1Sparkle")?.hidden = false
                self.emojiButton2?.childNodeWithName("emoji2Sparkle")?.hidden = false
                
                if (self.roundsPlayed == self.maxRounds) {
                    self.restartGame()
                } else {
                    self.currentGameMode = 1
                }
            })
        })
    }
    
    
    func resetButtonAndEmojiParameters() {
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
        colorFieldRight?.runAction(fadeInAction, completion: { 
            self.blockInteraction = false
        })
        
    }
    
    
    func getRandomValue(fromRange: Int, lastValue: Int) -> Int {
        var randomIndex = Int(arc4random_uniform(UInt32(fromRange)))
        while (randomIndex == lastValue) {
            randomIndex = Int(arc4random_uniform(UInt32(fromRange)))
        }
        return randomIndex
    }
    
    func setupEmojiMood(emojiNumber:Int, leftOrRight: Int) {
        var angryValue: Bool
        var tiredValue: Bool
        var twinkerValue: Bool
        switch emojiNumber {
        case 0:             //happy
            angryValue = true
            tiredValue = false
            twinkerValue = false
        case 1:             //flushed
            angryValue = false
            tiredValue = false
            twinkerValue = true
        case 2:             //love
            angryValue = false
            tiredValue = false
            twinkerValue = false
        case 3:             // mouth
            angryValue = true
            tiredValue = false
            twinkerValue = false
        case 4:             //tongue
            angryValue = false
            tiredValue = false
            twinkerValue = true
        case 5:             //twinker
            angryValue = false
            tiredValue = false
            twinkerValue = true
        case 6:             //upside
            angryValue = false
            tiredValue = true
            twinkerValue = false
        case 7:             //hushed
            angryValue = false
            tiredValue = true
            twinkerValue = false
        case 8:             //kiss
            angryValue = false
            tiredValue = false
            twinkerValue = true
        case 9:             //neutral1
            angryValue = false
            tiredValue = true
            twinkerValue = false
        case 10:             //neutral2
            angryValue = false
            tiredValue = true
            twinkerValue = false
        case 11:             //smile
            angryValue = false
            tiredValue = true
            twinkerValue = false
        case 12:             //sad1
            angryValue = true
            tiredValue = false
            twinkerValue = false
        case 13:             //sad2
            angryValue = true
            tiredValue = false
            twinkerValue = false
        case 14:             //tears1
            angryValue = true
            tiredValue = false
            twinkerValue = false
        case 15:             //tears2
            angryValue = true
            tiredValue = false
            twinkerValue = false
        case 16:             //sad angry
            angryValue = true
            tiredValue = false
            twinkerValue = false
        case 17:             //sad neg
            angryValue = true
            tiredValue = false
            twinkerValue = false
        case 18:             //teeth
            angryValue = true
            tiredValue = false
            twinkerValue = false
        case 19:             //sick
            angryValue = true
            tiredValue = false
            twinkerValue = false
        case 20:             //xx
            angryValue = true
            tiredValue = false
            twinkerValue = false
            
        default:
            angryValue = false
            tiredValue = false
            twinkerValue = false
            
        }
        
        if (leftOrRight == 1) {
            emoji1Angry = angryValue
            emoji1Tired = tiredValue
            emoji1Twike = twinkerValue
            
        } else if (leftOrRight == 2) {
            emoji2Angry = angryValue
            emoji2Tired = tiredValue
            emoji2Twike = twinkerValue
            
        }
        
    }
    
    func perfomAngryFinal() {
        //
        
    }
    func performTiredFinal() {
        //
    }
    func resetColorAreas() {
        colorFieldLeft?.alpha = 0.0
        colorFieldRight?.alpha = 0.0
        colorLineLeft?.alpha = 0.0
        colorLineRight?.alpha = 0.0
    }
    
    func restartGame() {
        // restart
     
        let transition = SKTransition.fadeWithDuration(1.0)
        
        let nextScene = TitleScene(fileNamed: "TitleScene")
        nextScene!.scaleMode = .AspectFill
        
        self.scene?.view?.presentScene(nextScene!, transition: transition)
        
    }
    
}

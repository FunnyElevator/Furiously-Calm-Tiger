//
//  GameScene.swift
//  Furiously Calm Tiger
//
//  Created by Fabian on 02.05.16.
//  Copyright (c) 2016 Fabian. All rights reserved.
//

import SpriteKit
import Flurry_iOS_SDK

class GameScene: SKScene {
    
    // UI Elements
    var colorFieldLeft: SKSpriteNode?
    var colorFieldRight: SKSpriteNode?
    var colorLineLeft: SKSpriteNode?
    var colorLineRight: SKSpriteNode?
    
    var rectCenterRotate1: SKSpriteNode?
    var rectCenterRotate2: SKSpriteNode?
    var rectCenterFill: SKSpriteNode?
    var rectCenterFrame: SKSpriteNode?
    var rectColorSmallFillL: SKSpriteNode?
    var rectColorSmallFrameL: SKSpriteNode?
    var rectColorSmallFillR: SKSpriteNode?
    var rectColorSmallFrameR: SKSpriteNode?
    
    var emojiButton1: SKSpriteNode?
    var emojiButton2: SKSpriteNode?
    var smallCirclesL: SKNode?
    var smallCirclesR: SKNode?
    
    var theTiger: SKNode?
    var tigerSnooze: SKNode?
    let tigerMouthOpen = SKSpriteNode(imageNamed: "TigerMouthOpen")
    let tigerMouthClosed1 = SKSpriteNode(imageNamed: "TigerMouthClosed1")
    let tigerMouthClosed2 = SKSpriteNode(imageNamed: "TigerMouthClosed2")
    
    var emoji1Sparkle: SKEmitterNode?
    var emoji2Sparkle: SKEmitterNode?
    
    // Logging Parameters
    var lastEmoji1Number: Int = 0
    var lastEmoji2Number: Int = 0
    var sessionParams = [String: String]()
    var roundParams = ["colorL": "nil",
                       "colorR": "nil",
                       "colorS": "nil",
                       "emojiL": "nil",
                       "emojiR": "nil",
                       "emojiS": "nil"]
    
    //  Tiger Mood Parameters
    var tigerMoodAngryIndex: Int = 0
    var tigerMoodTiredIndex: Int = 0
    var tigerMoodTwinkeIndex: Bool = false
    
    var emoji1Angry: Bool = false
    var emoji1Tired: Bool = false
    var emoji1Twike: Bool = false
    var emoji2Angry: Bool = false
    var emoji2Tired: Bool = false
    var emoji2Twike: Bool = false
    

    // GLOBAL parameters
    var emojis = [SKTexture]()
    var lastEmoji:Int = 0
    var colors = [UIColor]()
    var lastColor: Int = 0
    
    var blockInteraction: Bool = false
    
    var currentGameMode: Int = 1
            /*  1: preEmoji
                2: EmojiSelect
                3: ColorSelect
                4: TigerReaction -> jump to Mode 2   */
    var roundsPlayed: Int = 0
            /*  If gameRound greather than maxRounds reset game */
    let maxRounds:Int = 3

    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        // Connect UI Elements from the Editor
        colorFieldLeft  = self.childNode(withName: "colorFieldLeft")  as? SKSpriteNode
        colorFieldRight = self.childNode(withName: "colorFieldRight") as? SKSpriteNode
        colorLineLeft   = self.childNode(withName: "colorLineLeft")  as? SKSpriteNode
        colorLineRight  = self.childNode(withName: "colorLineRight") as? SKSpriteNode
        emojiButton1    = self.childNode(withName: "emojiButton1") as? SKSpriteNode
        emojiButton2    = self.childNode(withName: "emojiButton2") as? SKSpriteNode
        smallCirclesL   = self.childNode(withName: "smallCirclesL")
        smallCirclesR   = self.childNode(withName: "smallCirclesR")
        
        rectCenterRotate1   = self.childNode(withName: "rectCenterRotate1") as! SKSpriteNode?
        rectCenterRotate2   = self.childNode(withName: "rectCenterRotate2") as! SKSpriteNode?
        rectCenterFill      = self.childNode(withName: "rectCenterFill") as! SKSpriteNode?
        rectCenterFrame     = self.childNode(withName: "rectCenterFrame") as! SKSpriteNode?
        rectColorSmallFillL = self.childNode(withName: "rectColorSmallFillL") as! SKSpriteNode?
        rectColorSmallFrameL = self.childNode(withName: "rectColorSmallFrameL") as! SKSpriteNode?
        rectColorSmallFillR  = self.childNode(withName: "rectColorSmallFillR") as! SKSpriteNode?
        rectColorSmallFrameR = self.childNode(withName: "rectColorSmallFrameR") as! SKSpriteNode?
        
        theTiger = self.childNode(withName: "Tiger")
        tigerSnooze = self.childNode(withName: "TigerSnooze")
        
        tigerMouthOpen.position = CGPoint(x: 0.0, y: 15.0)
        tigerMouthOpen.zPosition = 500
        tigerMouthOpen.alpha = 0.0
        theTiger!.addChild(tigerMouthOpen)

        tigerMouthClosed1.position = CGPoint(x: 0.0, y: 15.0)
        tigerMouthClosed1.zPosition = 500
        tigerMouthClosed1.alpha = 0.0
        theTiger!.addChild(tigerMouthClosed1)
        
        tigerMouthClosed2.position = CGPoint(x: 0.0, y: 15.0)
        tigerMouthClosed2.zPosition = 500
        theTiger!.addChild(tigerMouthClosed2)
        
        
        /* Prepare Interface elements */
        resetColorAreas()
        emojiButton1?.alpha = 0.0
        emojiButton2?.alpha = 0.0
        smallCirclesL?.isHidden = true
        smallCirclesR?.isHidden = true
        
        //Add sparkle emitters to Emoji Icons
        let roundparticlePath:NSString = Bundle.main.path(forResource: "RoundParticle2", ofType: "sks")! as NSString
        emoji1Sparkle = (NSKeyedUnarchiver.unarchiveObject(withFile: roundparticlePath as String) as! SKEmitterNode)
        emoji1Sparkle!.position = CGPoint(x: 0.0, y: 0.0)
        emoji1Sparkle!.name = "emoji1Sparkle"
        emoji1Sparkle!.zPosition = -1
        emojiButton1?.addChild(emoji1Sparkle!)
        
        emoji2Sparkle = (NSKeyedUnarchiver.unarchiveObject(withFile: roundparticlePath as String) as! SKEmitterNode)
        emoji2Sparkle!.position = CGPoint(x: 0.0, y: 0.0)
        emoji2Sparkle!.name = "emoji2Sparkle"
        emoji2Sparkle!.zPosition = -1
        emojiButton2?.addChild(emoji2Sparkle!)
        
        // Add and hide Outlines to EmojiButtons
        let circleEmoji = SKShapeNode(circleOfRadius: 44.5 ) // Size of Circle
        circleEmoji.fillColor = SKColor.white
        circleEmoji.position = CGPoint(x: 0.0, y: 0.0)
        circleEmoji.zPosition = -5
        circleEmoji.name = "circleEmoji"
        circleEmoji.isHidden = true
        emojiButton1?.addChild(circleEmoji)
        
        let circleEmoji2 = SKShapeNode(circleOfRadius: 44.5 ) // Size of Circle
        circleEmoji2.fillColor = SKColor.white
        circleEmoji2.position = CGPoint(x: 0.0, y: 0.0)
        circleEmoji2.zPosition = -5
        circleEmoji2.name = "circleEmoji"
        circleEmoji2.isHidden = true
        emojiButton2?.addChild(circleEmoji2)
        
        // Setup Emoji Textures
        emojis = [
            // (removed in v2) SKTexture(imageNamed: "emoji-happy-1f61b"),
            SKTexture(imageNamed: "emoji-happy-flushed-1f60a"),
            // (removed in v2) SKTexture(imageNamed: "emoji-happy-love-1f60d"),
            SKTexture(imageNamed: "emoji-happy-mouth-1f600"),
            // (removed in v2) SKTexture(imageNamed: "emoji-happy-tongue-1f61c"),
            SKTexture(imageNamed: "emoji-happy-twinker-1f609"),
            // (removed in v2) SKTexture(imageNamed: "emoji-happy-upside-1f643"),
            // (removed in v2) SKTexture(imageNamed: "emoji-hushed-1f62f"),
            // (removed in v2) SKTexture(imageNamed: "emoji-kiss-1f617"),
            // (removed in v2) SKTexture(imageNamed: "emoji-neutral-1f610"),
            // (removed in v2) SKTexture(imageNamed: "emoji-neutral-1f636"),
            // (removed in v2) SKTexture(imageNamed: "emoji-neutral-1f644"),
            SKTexture(imageNamed: "emoji-positive-1f642"),
            SKTexture(imageNamed: "emoji-sad-1f61f"),
            // (removed in v2) SKTexture(imageNamed: "emoji-sad-1f626"),
            SKTexture(imageNamed: "emoji-sad-cry-1f622"),
            // (removed in v2) SKTexture(imageNamed: "emoji-sad-cry-1f625"),
            // (removed in v2) SKTexture(imageNamed: "emoji-sad-flushed-1f623"),
            SKTexture(imageNamed: "emoji-sad-mouth-1f62b"),
            // (removed in v2) SKTexture(imageNamed: "emoji-sad-teeth-1f62c"),
             SKTexture(imageNamed: "emoji-unhappy-sick-1f915")
            // (removed in v2) SKTexture(imageNamed: "emoji-xx-1f635")
        ]
        
        // Setup Colors
        colors = [
              UIColor(red: 217/255, green: 30/255,  blue: 24/255,  alpha: 1.0),
              UIColor(red: 103/255, green: 65/255,  blue: 114/255, alpha: 1.0),
            //UIColor(red: 210/255, green: 77/255,  blue: 87/255,  alpha: 1.0),
            //UIColor(red: 129/255, green: 207/255, blue: 224/255, alpha: 1.0),
            
            //UIColor(red: 52/255,  green: 152/255, blue: 219/255, alpha: 1.0),
              UIColor(red: 25/255,  green: 181/255, blue: 254/255, alpha: 1.0),
            //UIColor(red: 58/255,  green: 83/255,  blue: 155/255, alpha: 1.0),
              UIColor(red: 37/255,  green: 116/255, blue: 169/255, alpha: 1.0),
            
            //UIColor(red: 31/255,  green: 58/255,  blue: 147/255, alpha: 1.0),
            //UIColor(red: 137/255, green: 196/255, blue: 244/255, alpha: 1.0),
            //UIColor(red: 135/255, green: 211/255, blue: 124/255, alpha: 1.0),
            //UIColor(red: 38/255,  green: 166/255, blue: 91/255,  alpha: 1.0),
            
              UIColor(red: 27/255,  green: 163/255, blue: 156/255, alpha: 1.0),
            //UIColor(red: 134/255, green: 226/255, blue: 213/255, alpha: 1.0),
              UIColor(red: 46/255,  green: 204/255, blue: 113/255, alpha: 1.0),
            //UIColor(red: 3/255,   green: 166/255, blue: 120/255, alpha: 1.0),
            
            //UIColor(red: 42/255,  green: 187/255, blue: 155/255, alpha: 1.0),
            //UIColor(red: 30/255,  green: 130/255, blue: 76/255,  alpha: 1.0),
              UIColor(red: 232/255, green: 126/255, blue: 4/255,   alpha: 1.0),
            //UIColor(red: 242/255, green: 120/255, blue: 75/255,  alpha: 1.0),
            
            //UIColor(red: 211/255, green: 84/255,  blue: 0/255,   alpha: 1.0),
              UIColor(red: 249/255, green: 191/255, blue: 59/255,  alpha: 1.0)
        ]
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.location(in: self)
            
            //remove previous partcile emitters
            for child in self.children {
                if child.name == "sparkEmmitter" {
                    child.removeFromParent()
                }
            }
            
            let touchedNode = atPoint(location)
            if (blockInteraction == false) {
                if (currentGameMode == 1) {
                    currentGameMode += 1
                    
                    setupEmojiSelect()
                } else if (currentGameMode == 2) {
                    if (touchedNode.name == "emojiButton1") {
                        performEmojiSelect(1)
                        print("Logging: Emoji 1")
                    } else if (touchedNode.name == "emojiButton2") {
                        performEmojiSelect(2)
                        print("Logging: Emoji 2")
                    }
                } else if (currentGameMode == 3) {
                    if (touchedNode.name == "colorFieldLeft") {
                        performColorSelect(1)
                        print("Logging: Color 1")
                    } else if (touchedNode.name == "colorFieldRight") {
                        performColorSelect(2)
                        print("Logging: Color 2")
                    }
                }
                
                // create touch circle effect
                let roundparticlePath:NSString = Bundle.main.path(forResource: "RoundParticle", ofType: "sks")! as NSString
                let sparkEmmiter = NSKeyedUnarchiver.unarchiveObject(withFile: roundparticlePath as String) as! SKEmitterNode
                sparkEmmiter.position = location
                sparkEmmiter.name = "sparkEmmitter"
                sparkEmmiter.zPosition = 400
                //sparkEmmiter.targetNode = self
                self.addChild(sparkEmmiter)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch : AnyObject in touches {
            
            let location : CGPoint = touch.location(in: self)
            let nodes : Array = self.nodes(at: location)
            for node in nodes {
                // Select a node by it's name
                if (currentGameMode == 3) {
                    if (node.name == "emojiButton1" || node.name == "emojiButton2") {
                        node.position = location
                        
                        if (location.y > 187) {
                            let moveToCenter = SKAction.move(to: CGPoint(x: 512, y: 88), duration: 0.5)
                            moveToCenter.timingMode = SKActionTimingMode.easeOut
                            node.run(moveToCenter)
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches {
            
            let location : CGPoint = touch.location(in: self)
            let nodes : Array = self.nodes(at: location)
            for node in nodes {
                if (currentGameMode == 3 && blockInteraction == false) {
                    if (node.name == "emojiButton1" || node.name == "emojiButton2") {
                        if (node.position.x == 512 && node.position.y == 88){
                        } else {
                            let moveToCenter = SKAction.move(to: CGPoint(x: 512, y: 88), duration: 0.4)
                            moveToCenter.timingMode = SKActionTimingMode.easeOut
                            node.run(moveToCenter)
                        }
                    
                    }
                }
            }
        }
    }

   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func setupEmojiSelect() {
        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        
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
    
        emojiButton1?.run(fadeInAction)
        emojiButton2?.run(fadeInAction)
        
        // Analytics: set round parameters
        roundParams["emojiL"] = String(leftEmoji)
        roundParams["emojiR"] = String(rightEmoji)
    }
    
    func performEmojiSelect(_ buttonNr: Int) {
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let moveToCenter = SKAction.moveTo(x: 512, duration: 0.8)
        blockInteraction = true
        
        var emojiSelectedAngry = false
        var emojiSelectedTired = false
        var emojiSelectedTwinker = false
        
        // Analytics
        roundParams["emojiS"] = String(buttonNr)
        
        func UIchanges () {
            emojiButton1?.childNode(withName: "circleEmoji")?.isHidden = false
            emojiButton2?.childNode(withName: "circleEmoji")?.isHidden = false
            emojiButton1?.childNode(withName: "emoji1Sparkle")?.isHidden = true
            emojiButton2?.childNode(withName: "emoji2Sparkle")?.isHidden = true
            self.smallCirclesL?.isHidden = false
            self.smallCirclesR?.isHidden = false
        }
        
        
        if buttonNr == 1 {
            emojiButton2?.run(fadeOut)
            emojiButton1?.run(moveToCenter, completion: { 
                UIchanges()
            })
            emojiSelectedTired = emoji1Tired
            emojiSelectedAngry = emoji1Angry
            emojiSelectedTwinker = emoji1Twike
        } else if buttonNr == 2 {
            emojiButton1?.run(fadeOut)
            emojiButton2?.run(moveToCenter, completion: {
                UIchanges()
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
    
    func performColorSelect(_ buttonNr: Int) {
        currentGameMode += 1
        blockInteraction = true
        
        // Analytics 
        roundParams["colorS"] = String(buttonNr)
        
        // UI changes
        var colorButtonCenter:CGFloat = 0.0
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        self.smallCirclesL?.isHidden = true
        self.smallCirclesR?.isHidden = true
        
        
        
        print("Run color function")
        if (buttonNr == 1) {
            colorButtonCenter = (colorFieldLeft?.position.x)!
            self.colorFieldRight?.run(fadeOutAction)
            self.colorLineRight?.run(fadeOutAction)
        } else if (buttonNr == 2) {
            colorButtonCenter = (colorFieldRight?.position.x)!
            self.colorFieldLeft?.run(fadeOutAction)
            self.colorLineLeft?.run(fadeOutAction)
        }
        let moveAction = SKAction.move(to: CGPoint(x: colorButtonCenter, y: 88) , duration: 0.5)
        moveAction.timingMode = SKActionTimingMode.easeInEaseOut
        
        if (emojiButton2?.alpha == 0.0) {
            emojiButton1?.run(moveAction, completion: {
                self.perfomTigerReaction()
            })
        } else if (emojiButton1?.alpha == 0.0) {
            emojiButton2?.run(moveAction, completion: {
                self.perfomTigerReaction()
            })
        }
    }
    
    func perfomTigerReaction() {
        // remove UI elements Done in runAfterTigerMood()
        
        // Analytics: Send RoundData (Started in ...)
        Flurry.endTimedEvent("roundCompleted", withParameters: roundParams);
        roundParams.removeAll()
        
        let waitAction = SKAction.wait(forDuration: 2)
        roundsPlayed += 1
        if (tigerMoodTiredIndex > 0) {
            let fadeInSnooze = SKAction.fadeIn(withDuration: 0.5)
            let fadeOutSnooze = SKAction.fadeOut(withDuration: 0.5)
            let waitAction2 = SKAction.wait(forDuration: 2)
            
            tigerSnooze?.run(SKAction.sequence([fadeInSnooze, waitAction2, fadeOutSnooze]), completion: {
                self.runAfterTigerMood()
            })
        } else if (tigerMoodAngryIndex > 0){
            tigerMouthOpen.yScale = 0.1
            tigerMouthOpen.alpha = 1
            let openingMouth = SKAction.scaleY(to: 1, duration: 0.2)
            let closingMouth = SKAction.scaleY(to: 0.1, duration: 0.2)
            let waitAction3 = SKAction.wait(forDuration: 0.2)
            
            tigerMouthClosed2.run(SKAction.fadeAlpha(to: 0.0, duration: 0.2))
            tigerMouthOpen.run(SKAction.sequence([openingMouth, waitAction3, closingMouth, waitAction3, openingMouth, waitAction3, closingMouth]), completion: {
                self.tigerMouthClosed2.run(SKAction.fadeAlpha(to: 1.0, duration: 0.2))
                self.tigerMouthOpen.run(SKAction.fadeAlpha(to: 0.0, duration: 0.2))
                self.runAfterTigerMood()
            })
        } else {
            self.run(waitAction, completion: { 
                self.runAfterTigerMood()
                
            })
        }
    }
    func runAfterTigerMood() {
        // resetting UI elements & parameters
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        
        self.emojiButton1?.run(fadeOutAction)
        self.emojiButton2?.run(fadeOutAction, completion: {
            self.emojiButton1?.position = CGPoint(x: 442, y: 88)
            self.emojiButton2?.position = CGPoint(x: 582, y: 88)
            self.colorFieldRight?.run(fadeOutAction)
            self.colorFieldLeft?.run(fadeOutAction)
            self.colorLineLeft?.run(fadeOutAction)
            self.colorLineRight?.run(fadeOutAction)
            self.blockInteraction = false
            self.emojiButton1?.childNode(withName: "emoji1Sparkle")?.isHidden = false
            self.emojiButton2?.childNode(withName: "emoji2Sparkle")?.isHidden = false
            self.emojiButton1?.childNode(withName: "circleEmoji")?.isHidden = true
            self.emojiButton2?.childNode(withName: "circleEmoji")?.isHidden = true
            
            if (self.roundsPlayed == self.maxRounds) {
                self.restartGame()
            } else {
                self.currentGameMode = 1
            }
        })
    }
    
    
    func setupColorSelect() {
        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        
        let leftColorValue = getRandomValue(colors.count, lastValue: lastColor)
        colorFieldLeft?.color = colors[leftColorValue]
        lastColor = leftColorValue
        
        let rightColorValue = getRandomValue(colors.count, lastValue: lastColor)
        colorFieldRight?.color = colors[rightColorValue]
        lastColor = rightColorValue
        
        colorLineLeft?.run(fadeInAction)
        colorLineRight?.run(fadeInAction)
        colorFieldLeft?.run(fadeInAction)
        colorFieldRight?.run(fadeInAction, completion: { 
            self.blockInteraction = false
        })
        
        // Analytics: Set round parameters (colors) & Start round
        Flurry.logEvent("roundCompleted", withParameters: nil, timed: true);
        roundParams["colorL"] = String(leftColorValue)
        roundParams["colorR"] = String(rightColorValue)
    }
    
    
    func getRandomValue(_ fromRange: Int, lastValue: Int) -> Int {
        var randomIndex = Int(arc4random_uniform(UInt32(fromRange)))
        while (randomIndex == lastValue) {
            randomIndex = Int(arc4random_uniform(UInt32(fromRange)))
        }
        return randomIndex
    }
    
    func setupEmojiMood(_ emojiNumber:Int, leftOrRight: Int) {
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
        
        rectCenterFill?.alpha = 0.0
        rectCenterFrame?.alpha = 0.0
        rectCenterRotate1?.alpha = 0.0
        rectCenterRotate2?.alpha = 0.0
        rectColorSmallFillL?.alpha = 0.0
        rectColorSmallFillR?.alpha = 0.0
        rectColorSmallFrameL?.alpha = 0.0
        rectColorSmallFrameR?.alpha = 0.0
    }
    
    func restartGame() {
        // restart the game
        
        // send Session Analytics
        // Started in TitleScene
        sessionParams["roundsPlayed"] = String(roundsPlayed)
        Flurry.endTimedEvent("GameSession_Complete", withParameters: nil);
        sessionParams.removeAll()
        
        // smoke effect
        let particlePath:NSString = Bundle.main.path(forResource: "SmokeParticles", ofType: "sks")! as NSString
        let sparkEmmiter = NSKeyedUnarchiver.unarchiveObject(withFile: particlePath as String) as! SKEmitterNode
        sparkEmmiter.position = CGPoint(x: 512, y: 180)
        sparkEmmiter.name = "sparkEmmitter"
        sparkEmmiter.zPosition = 400
        //sparkEmmiter.targetNode = self
        self.addChild(sparkEmmiter)
        
        
        self.run(SKAction.wait(forDuration: 3), completion: {
            let transition = SKTransition.fade(withDuration: 2.5)
            
            let nextScene = TitleScene(fileNamed: "TitleScene")
            nextScene!.scaleMode = .aspectFill
            
            self.scene?.view?.presentScene(nextScene!, transition: transition)
        }) 
        
        
    }
    
}

//
//  GameScene.swift
//  Tappable
//
//  Created by Shanta Adhikari on 7/6/16.
//  Copyright (c) 2016 Make School. All rights reserved.
//

import SpriteKit

/* Tracking enum for game state */
enum GameState {
    case Playing, GameOver, Ready
}

class GameScene: SKScene {
    
    var tapBox: SKSpriteNode!
    
    var playButton: MSButtonNode!
    
    var score: Int = 0
    
    
    var scoreLabel: SKLabelNode!
    
    /* Game management */
    var state: GameState = .Playing
    
    var timeBar: SKSpriteNode!
    
    var over: SKLabelNode!
    
    var bestLabel: SKLabelNode!

    var gameState: GameState!
    
    var time: CGFloat = 1.0 {
        didSet {
            /* Scale time bar between 0.0 -> 1.0 e.g 0 -> 100% */
            timeBar.xScale = time
        }
    }

    override func didMoveToView(view: SKView) {
        
        tapBox = childNodeWithName("tapBox") as! SKSpriteNode
        
        timeBar = childNodeWithName("timeBar") as! SKSpriteNode
        
        scoreLabel = childNodeWithName("scoreLabel") as! SKLabelNode
        scoreLabel.hidden = true
        
        over = childNodeWithName("over") as! SKLabelNode
        over.hidden = true
        
        bestLabel = childNodeWithName("bestLabel") as! SKLabelNode
        bestLabel.text = String(NSUserDefaults.standardUserDefaults().integerForKey("bestLabel"))
        
        playButton = childNodeWithName("playButton") as! MSButtonNode
        
        playButton.hidden = false
        
        /* Setup play button selection handler */
        playButton.selectedHandler = {
            
            /* Start game */
            self.state = .Ready
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        /* Game not ready to play */
        if state == .GameOver { return }
        
        /* Game begins on first touch */
        if state == .Ready {
            state = .Playing
        }
        
        scoreLabel.hidden = true

        //make the tapBox disappear
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let node = self.nodeAtPoint(location)
            
            //hide playButton while playing the game
            playButton.hidden = true
            
            /* Increment Score */
            score += 1
            scoreLabel.text = String(score)
            
            if node.name == "tapBox"{
            node.removeFromParent()
                
                /* Create a new obstacle reference object using our obstacle resource */
                let resourcePath = NSBundle.mainBundle().pathForResource("TapBox", ofType: "sks")
                let newtapBox = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
                self.addChild(newtapBox)
                
                /* Generate new tap box */
                newtapBox.position = CGPointMake(CGFloat.random (min: 50, max: 290), CGFloat.random(min: 50, max: 450))
            }
        
            else {
                state = .GameOver
                gameOver()
            }
            
        }
        
    }

    
    override func update(currentTime: CFTimeInterval) {
        
        over.hidden = true
        
        if score > Int(bestLabel.text!){
            bestLabel.text = String(score)
        }
        
        if score > NSUserDefaults.standardUserDefaults().integerForKey("bestLabel"){
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "bestLabel")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        bestLabel.text = String(NSUserDefaults.standardUserDefaults().integerForKey("bestLabel"))
        
        /* Called before each frame is rendered */
        if state != .Playing { return }
        
        /* Decrease Health */
       // time -= 0.001
        
        /* Has the player run out of health? */
        if time < 0 {
            time = 0
            gameOver()
        }
        else {
            time -= 0.001

        }
    }
    
    func gameOver() {
        /* Game over! */
        
        state = .GameOver
        
        over.hidden = false
        
        playButton.hidden = false
        
        scoreLabel.hidden = false
        
        /* Change play button selection handler */
        playButton.selectedHandler = {
            
            /* Grab reference to the SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            /* Restart GameScene */
            skView.presentScene(scene)
        }

    }
        
}





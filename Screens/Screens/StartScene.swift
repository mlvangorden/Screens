//
//  GameScene.swift
//  Screens
//
//  Created by Matthew Van Gorden on 10/14/19.
//  Copyright © 2019 Matthew Van Gorden. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class StartScene: SKScene {
    
    var screenBounds = CGRect()
    var screen_width = CGFloat()
    var screen_height = CGFloat()
    
    var logo = SKSpriteNode()
    var play_button = SKSpriteNode()
    var leaderboard = SKSpriteNode()
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    override func didMove(to view: SKView) {
        screenBounds = UIScreen.main.bounds
        
        let temp_height = screenBounds.height
        let temp_width = screenBounds.width
        
        screen_width = min(temp_height, temp_width)
        screen_height = max(temp_height, temp_width)
        
        screen_width *= 2
        screen_height *= 2
        
        space_width = screen_width / 8
        space_height = space_width
        
        
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.view?.isMultipleTouchEnabled = false
        self.lastUpdateTime = 0
        
        logo = SKSpriteNode(imageNamed: "logo")
        logo.anchorPoint = CGPoint(x: 0, y: 1)
        logo.position = CGPoint(x: 0, y: 0)
        self.addChild(logo)
        
        play_button = SKSpriteNode(imageNamed: "play")
        play_button.anchorPoint = CGPoint(x: 0.5, y: 1)
        play_button.position = CGPoint(x: screen_width / 2, y: -1*(screen_height / 2))
        play_button.name = "PLAY"
        self.addChild(play_button)
        
        leaderboard = SKSpriteNode(imageNamed: "leaderboard")
        leaderboard.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leaderboard.position = CGPoint(x: screen_width / 2, y: -1*((screen_height / 2) + 400) )
        leaderboard.name = "LEADERBOARD"
        self.addChild(leaderboard)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if(self.atPoint(location).name == "PLAY") {
                let gameSceneTemp = GameScene(fileNamed: "GameScene")
                self.scene?.view?.presentScene(gameSceneTemp)
            } else if(self.atPoint(location).name == "LEADERBOARD") {
                //let gameSceneTemp = GameScene(fileNamed: )
            }
            
        }
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let previous_location = touch.previousLocation(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let previous_location = touch.previousLocation(in: self)
        }
    }
    
    override func update(_ currentTime: TimeInterval){
        // Called before each frame is rendered

        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}

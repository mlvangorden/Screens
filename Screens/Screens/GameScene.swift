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

var screenBounds = CGRect()
var screen_width = CGFloat()
var screen_height = CGFloat()

struct category {
    static let pig : UInt32 = 0x4
    static let bomb : UInt32 = 0x3
    static let hedgehog : UInt32 = 0x2
    static let garden : UInt32 = 0x1
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        screenBounds = UIScreen.main.bounds
        
        let temp_height = screenBounds.height
        let temp_width = screenBounds.width
        
        screen_width = max(temp_height, temp_width)
        screen_height = min(temp_height, temp_width)
        
        self.physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {

    }
    
    @objc func spawnPig(){
        let pig = Pig()
        self.addChild(pig)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
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

    }
}

class Pig : SKSpriteNode {
    var health = Int()
    
    init() {
        let texture = SKTexture(imageNamed: "pig")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        health = 5
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func takeDamage() {
        health -= 1
    }
    
    func death() {
        self.removeFromParent()
    }
    
}

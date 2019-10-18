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

let header_offset : CGFloat = 300
var space_height = CGFloat()
var space_width = CGFloat()

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    var board = [Space]()
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
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
        
        createBoard()
    }
    
    func createBoard() {
        for i in 0...31 {
            let space = Space(number: i)
            let column = i % 4
            let row = Int(i / 4)
            let odd = row % 2
            
            let x_offset = CGFloat(Double(column) * 2 + Double(odd) + (1.0/2.0))
            let y_offset = CGFloat(Double(row) + (1.0/2.0))
            
            let x_position : CGFloat = space_width * x_offset
            let y_position : CGFloat = -1 * (header_offset + space_height * y_offset )
            
            space.position = CGPoint(x: x_position, y: y_position)
            
            board.append(space)
        }
        for i in 0...31 {
            let column = i % 4
            let row = Int(i / 4)
            
            //North West
            if(row > 0 && column > 0) {
                board[i].setNeighbor(space: board[i-4], direction: "NW")
            }
            //North East
            if(row > 0 && column < 3) {
                board[i].setNeighbor(space: board[i-3], direction: "NE")
            }
            //South West
            if(row < 3 && column > 0) {
                board[i].setNeighbor(space: board[i+3], direction: "SW")
            }
            //South East
            if(row < 3 && column < 3) {
                board[i].setNeighbor(space: board[i+4], direction: "SE")
            }
            
            self.addChild(board[i])
        }
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

class Space : SKSpriteNode {
    
    private var num : Int
    private var NW = -1
    private var NE = -1
    private var SW = -1
    private var SE = -1
    
    init(number: Int) {
        num = number
        let texture = SKTexture(imageNamed: "space")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5) //change to (0,1)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNeighbor(space: Space, direction: String) {
        switch direction {
        case "NW":
            NW = space.getNumber()
            
        case "NE":
            NE = space.getNumber()
            
        case "SW":
            SW = space.getNumber()
            
        case "SE":
            SE = space.getNumber()
            
        default:
            return
        }
    }
    
    func getNeighbor(direction: String) -> Int {
        switch direction {
        case "NW":
            return NW
            
        case "NE":
            return NE
            
        case "SW":
            return SW
            
        case "SE":
            return SE
            
        default:
            return -1
        }
    }
    
    func getNumber() -> Int {
        return num
    }
}

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
let space_height : CGFloat = 93.75
let space_width : CGFloat = 93.75

class GameScene: SKScene {
    
    var board = [Space]()
    
    override func didMove(to view: SKView) {
        screenBounds = UIScreen.main.bounds
        
        let temp_height = screenBounds.height
        let temp_width = screenBounds.width
        
        screen_width = max(temp_height, temp_width)
        screen_height = min(temp_height, temp_width)
    }
    
    func createBoard() {
        for i in 0...31 {
            let space = Space(number: i)
            let column = i % 4
            let row = Int(i / 4)
            let odd = row % 2
            
            let x_offset = CGFloat((column * 2 + odd + (1/2)))
            let y_offset = CGFloat(2 * row - (1/2))
            
            let x_position : CGFloat = space_width * x_offset
            let y_position : CGFloat = (-1 * header_offset) - space_height * y_offset
            
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

    }
}

class Space : SKSpriteNode {
    
    var num : Int
    var NW = Space(number: -1)
    var NE = Space(number: -1)
    var SW = Space(number: -1)
    var SE = Space(number: -1)
    
    init(number: Int) {
        num = number
        let texture = SKTexture(imageNamed: "space")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNeighbor(space: Space, direction: String) {
        switch direction {
        case "NW":
            NW = space
            
        case "NE":
            NE = space
            
        case "SW":
            SW = space
            
        case "SE":
            SE = space
            
        default:
            return
        }
    }
    
    func getNeighbor(direction: String) -> Space {
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
            return Space(number: -1)
        }
    }
    
    func getNumber() -> Int {
        return num
    }
}

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

let header_offset : CGFloat = 187.5
var space_height = CGFloat()
var space_width = CGFloat()

let button_offset : CGFloat = 20.0
let arrow_dimensions : CGFloat = 168.25

var button_directions = [false, false, false, false]
var board = [Space]()
var arrows = [SKSpriteNode]()

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var player = Player(space: 0)
    var enemy1 = Enemy(space: 0)
    var enemy2 = Enemy(space: 0)
    
    private var lastUpdateTime : TimeInterval = 0
    
    override func sceneDidLoad() {
        self.view?.isMultipleTouchEnabled = false
        
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
        addArrows()
        startGame()
    }
    
    func startGame() {
        player = Player(space: 31)
        enemy1 = Enemy(space: 0)
        enemy2 = Enemy(space: 3)
        self.addChild(player)
        self.addChild(enemy1)
        self.addChild(enemy2)
        updateButtons()
    }
    
    func createBoard() {
        for i in 0...31 {
            let space = Space(number: i)
            let column = i % 4
            let row = Int(i / 4)
            let odd = row % 2
            
            let x_offset = CGFloat(Double(column) * 2 + Double(odd))
            let y_offset = CGFloat(Double(row))
            
            let x_position : CGFloat = space_width * x_offset
            let y_position : CGFloat = -1 * (header_offset + space_height * y_offset)
            
            space.position = CGPoint(x: x_position, y: y_position)
            
            board.append(space)
        }
        for i in 0...31 {
            let column = i % 4
            let row = Int(i / 4)
            let odd = row % 2 // odd is equal to 0 on rows <0> and <2>
            
            //North West
            if(row > 0 && (column > 0 || (column == 0 && odd == 1)) ) {
                board[i].setNeighbor(space: board[i - 5 + odd], direction: 0)
            }
            //North East
            if(row > 0 && (column < 3 || (column == 3 && odd == 0)) ) {
                board[i].setNeighbor(space: board[i - 4 + odd], direction: 3)
            }
            //South West
            if(row < 7 && (column > 0 || (column == 0 && odd == 1)) ) {
                board[i].setNeighbor(space: board[i + 3 + odd], direction: 1)
            }
            //South East
            if(row < 7 && (column < 3 || (column == 3 && odd == 0)) ) {
                board[i].setNeighbor(space: board[i + 4 + odd], direction: 2)
            }
            
            self.addChild(board[i])
        }
        print(board.count)
    }
    
    func addArrows() {
        for i in 0...3 {
            var image_name : String
            switch i {
            case 0:
                image_name = "arrow_nw"
            case 1:
                image_name = "arrow_sw"
            case 2:
                image_name = "arrow_se"
            case 3:
                image_name = "arrow_ne"
            default:
                image_name = "arrow_nw"
            }
            let arrow_button = SKSpriteNode(imageNamed: image_name)
            arrow_button.anchorPoint = CGPoint(x: 0, y: 1)
            arrow_button.name = image_name
            
            var x_position : CGFloat = (screen_width / 2) - (button_offset / 2) - arrow_dimensions
            var y_position : CGFloat = -1 * (screen_height - button_offset - arrow_dimensions)
            
            if(i % 3 == 0) {
                y_position += (button_offset + arrow_dimensions)
            }
            if(i > 1) {
                x_position += (button_offset + arrow_dimensions)
            }
            
            arrow_button.position = CGPoint(x: x_position, y: y_position)

            arrows.append(arrow_button)
            self.addChild(arrow_button)
            
        }
    }
    
    func updateButtons() {
        for i in 0...3 {
            let arrow = arrows[i]
            if (player.getNeighbor(direction: i) == -1) {
                arrow.texture = SKTexture(imageNamed: arrow.name! + "2")
            } else {
                arrow.texture = SKTexture(imageNamed: arrow.name!)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            checkButtonPress(location: location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let previous_location = touch.previousLocation(in: self)
            checkButtonPress(location: location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let previous_location = touch.previousLocation(in: self)
                movePlayer()
            }
    }
    
    func checkButtonPress(location: CGPoint) {
        for i in 0...3 {
            if (arrows[i].contains(location)) {
                button_directions[i] = true
            } else {
                button_directions[i] = false
            }
        }
    }
    
    func movePlayer() {
        for i in 0...3 {
            if(button_directions[i]) {
                player.move_direction(direction: i)
                player.updateNeighbors()
                updateButtons()
                return
            }
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
        self.anchorPoint = CGPoint(x: 0, y: 1)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNeighbor(space: Space, direction: Int) {
        
        switch direction {
        case 0:
            NW = space.getNumber()
            
        case 3:
            NE = space.getNumber()
            
        case 1:
            SW = space.getNumber()
            
        case 2:
            SE = space.getNumber()
            
        default:
            return
        }
    }
    
    func getNeighbor(direction: Int) -> Int {
        switch direction {
        case 0:
            return NW
            
        case 3:
            return NE
            
        case 1:
            return SW
            
        case 2:
            return SE
            
        default:
            return -1
        }
    }
    
    func getNumber() -> Int {
        return num
    }
}

class Character : SKSpriteNode {
    
    var pos : Int
    var neighbors = [-1, -1, -1, -1]
    
    init(space: Int) {
        pos = space
        let texture = SKTexture(imageNamed: "player")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.anchorPoint = CGPoint(x: 0, y: 1)
        if(board.count > 0){
            self.position = board[pos].position
        }
        self.zPosition = 1
        updateNeighbors()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move_direction(direction: Int) {
        if(board.count > 0){
            let temp = getNeighbor(direction: direction)
            if(temp != -1) {
                pos = temp
                self.run(SKAction.move(to: board[pos].position, duration: 0.25))
            }
        }
    }
    
    func get_position() -> Int {
        return pos
    }
    
    func getNeighbor(direction: Int) -> Int {
        if (board.count >  0) {
            return board[pos].getNeighbor(direction: direction)
        }
        return -1
    }
    
    func updateNeighbors() {
        neighbors[0] = getNeighbor(direction: 0)
        neighbors[1] = getNeighbor(direction: 1)
        neighbors[2] = getNeighbor(direction: 2)
        neighbors[3] = getNeighbor(direction: 3)
    }
}

class Player : Character {
    override init(space: Int) {
        super.init(space: space)
        self.name = "Player"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Enemy : Character {
    override init(space: Int) {
        super.init(space: space)
        let texture = SKTexture(imageNamed: "enemy")
        self.texture = texture
        self.name = "Enemy"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

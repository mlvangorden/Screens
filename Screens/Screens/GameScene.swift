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
var arrows = [Arrow]()

var score = 0

class GameScene: SKScene {
    
    var viewController = GameViewController()
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var player = Player(space: 0)
    var enemy1 = Enemy(space: 0)
    var enemy2 = Enemy(space: 0)
    var star = Star(space: 0)
    
    var score_display = SKLabelNode()
    
    var waiting_for_move : Bool = false
    
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
        player.removeFromParent()
        enemy1.removeFromParent()
        enemy2.removeFromParent()
        score_display.removeFromParent()
        score = 0
        
        player = Player(space: 27)
        enemy1 = Enemy(space: 0)
        enemy2 = Enemy(space: 3)
        self.addChild(player)
        self.addChild(enemy1)
        self.addChild(enemy2)
        
        score_display.fontName = "Times"
        score_display.horizontalAlignmentMode = .center
        score_display.position = CGPoint(x: screen_width / 2, y: -125)
        score_display.zPosition = 1
        score_display.fontColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        score_display.fontSize = 80
        score_display.text = String(score)
        self.addChild(score_display)
        
        spawnStar()
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
            
            board[i].removeFromParent()
            self.addChild(board[i])
        }
    }
    
    func addArrows() {
        for i in 0...3 {
            let arrow = Arrow(direction: i)

            arrows.append(arrow)
            self.addChild(arrow)
        }
    }
    
    func updateButtons() {
        for i in 0...3 {
            let arrow = arrows[i]
            if (player.getNeighbor(direction: i) == -1) {
                arrow.deactivate()
            } else {
                arrow.activate()
            }
        }
    }
    
    func spawnStar() {
        star.removeFromParent()
        var random_int = Int.random(in: 0..<32)
        
        while  ( random_int == player.get_position() || random_int == enemy1.get_position() || random_int == enemy2.get_position() || enemy1.checkNeighbor(neighbor: random_int) || enemy2.checkNeighbor(neighbor: random_int) || player.checkNeighbor(neighbor: random_int) ) {
            random_int = Int.random(in: 0..<32)
        }
        star = Star(space: random_int)
        self.addChild(star)
    }
    
    func scoreStar(){
        score += 1
        score_display.text = String(score)
    }
    
    func getScore() -> Int {
        return score
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!waiting_for_move){
            for touch in touches {
                let location = touch.location(in: self)
                checkButtonPress(location: location)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!waiting_for_move) {
            for touch in touches {
                let location = touch.location(in: self)
                let previous_location = touch.previousLocation(in: self)
                checkButtonPress(location: location)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!waiting_for_move) {
            for touch in touches {
                let previous_location = touch.previousLocation(in: self)
                movePlayer()
                button_directions = [false, false, false, false]
            }
        }
    }
    
    func checkButtonPress(location: CGPoint) {
        for i in 0...3 {
            if (arrows[i].contains(location) && arrows[i].active) {
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
                updateButtons()
                moveEnemies()
                waiting_for_move = true
                break
            }
        }
    }
    
    func moveEnemies() {
        for enemy in [enemy1, enemy2] {
            var possible_directions = [false, false, false, false]
            for i in 0...3 {
                if (enemy.getNeighbor(direction: i) != -1) {
                    possible_directions[i] = true
                }
                if (enemy.getNeighbor(direction: i) == star.get_position() || enemy.getNeighbor(direction: i) == enemy1.get_position()) {
                    possible_directions[i] = false
                }
            }
            if(possible_directions == [false, false, false, false]) {
                for i in 0...3 {
                    if ( enemy.getNeighbor(direction: i) == enemy1.get_position() ) {
                        possible_directions[i] = true
                    }
                }
            }
            
            var random_direction = Int.random(in: 0..<4)
            while (possible_directions[random_direction] == false) {
                random_direction = Int.random(in: 0..<4)
            }
            enemy.move_direction(direction: random_direction)
        }
    }
    
    override func update(_ currentTime: TimeInterval){
        // Called before each frame is rendered
        
        if(player.position == board[player.get_position()].position) {
            waiting_for_move = false
        }
        
        //losing condition
        if(player.position == enemy1.position || player.position == enemy2.position) {
            viewController.endVoyage()
        }
        //scoring condition
        else if (player.position == star.position) {
            scoreStar()
            spawnStar()
        }
        
        
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

class Arrow : SKSpriteNode {
    var active : Bool = true
    var dir : Int = -1
    
    init(direction: Int) {
        dir = direction
        var image_name : String
        switch dir {
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
        let texture = SKTexture(imageNamed: image_name)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.name = image_name
        self.zPosition = 1
        
        var x_position : CGFloat = (screen_width / 2) - (button_offset / 2) - arrow_dimensions
        var y_position : CGFloat = -1 * (screen_height - button_offset - arrow_dimensions)
        
        if(dir % 3 == 0) {
            y_position += (button_offset + arrow_dimensions)
        }
        if(dir > 1) {
            x_position += (button_offset + arrow_dimensions)
        }
        self.position = CGPoint(x: x_position, y: y_position)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func deactivate() {
        var image_name : String
        switch dir {
        case 0:
            image_name = "arrow_nw2"
        case 1:
            image_name = "arrow_sw2"
        case 2:
            image_name = "arrow_se2"
        case 3:
            image_name = "arrow_ne2"
        default:
            image_name = "arrow_nw2"
        }
        self.texture = SKTexture(imageNamed: image_name)
        self.name = image_name
        active = false
    }
    
    func activate() {
        var image_name : String
        switch dir {
        case 0:
            image_name = "arrow_nw"
        case 1:
            image_name = "arrow_sw"
        case 2:
            image_name = "arrow_se"
        case 3:
            image_name = "arrow_ne"
        default:
            image_name = "arrow_nw2"
        }
        self.texture = SKTexture(imageNamed: image_name)
        self.name = image_name
        active = true
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
                self.run(SKAction.move(to: board[pos].position, duration: 0.2))
                updateNeighbors()
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
    
    func checkNeighbor(neighbor: Int) -> Bool {
        for n in neighbors {
            if (n == neighbor) {
                return true
            }
        }
        return false
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

class Star : Character {
    override init(space: Int) {
        super.init(space: space)
        let texture = SKTexture(imageNamed: "star")
        self.texture = texture
        self.name = "Star"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

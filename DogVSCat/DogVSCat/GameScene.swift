//
//  GameScene.swift
//  DogVSCat
//
//  Created by Ligia Naomi Nakase on 25/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var dog: SKSpriteNode!
    var basket: SKSpriteNode!
    
    var collectedItems = 0
    
    var itemLabel: SKLabelNode!
    
    var itemCount: Int = 0 {
        didSet {
            itemLabel.text = "Items: \(itemCount)"
        }
    }
    
    override func didMove(to view: SKView) {
        dog = childNode(withName: "dog") as? SKSpriteNode
        basket = childNode(withName: "basket") as? SKSpriteNode
        
        itemLabel = childNode(withName: "items") as? SKLabelNode
        
        startItemSpawn()
        
    }
    
    func startItemSpawn() {
        let spawnAction = SKAction.run(spawnItem)
        let delayAction = SKAction.wait(forDuration: 1.5)
        let sequenceAction = SKAction.sequence([spawnAction, delayAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        run(repeatAction)
    }
    
    func spawnItem() {
        let item = childNode(withName: "bolinha") as! SKSpriteNode
//        item.name = "item"
        
        item.run(SKAction.moveTo(x: -100, duration: 1.0))
//        item.position = CGPoint(x: spawnX, y: spawnY)
//        addChild(item)
        if item.position.x > 1000 {
            item.removeFromParent()
            item.position = CGPoint(x: 215.5, y: 442.5)
            item.zPosition = 11
            addChild(item)
        }
        
        
        
        
//        let moveAction = SKAction.moveTo(y: -300, duration: 5)
//        let removeAction = SKAction.removeFromParent()
//        let sequenceAction = SKAction.sequence([moveAction, removeAction])
//        item.run(sequenceAction)
        
        
        
//        item.physicsBody = SKPhysicsBody(rectangleOf: item.size)
//        item.physicsBody?.categoryBitMask = 1
//        item.physicsBody?.contactTestBitMask = 1
//        item.physicsBody?.collisionBitMask = 0
//        item.physicsBody?.affectedByGravity = true
    }
    
//    func spawnItem() {
//        let item = SKSpriteNode(imageNamed: "item")
//        item.name = "item"
//        
//        let spawnX = size.width / 2 // Fixed x-coordinate
//        let spawnY = size.height
//        
//        item.zPosition = 5
//        item.position = CGPoint(x: spawnX, y: spawnY)
//        addChild(item)
//        
//        // Adjust the impulse range based on desired y-positions
//        let impulseX: CGFloat = CGFloat.random(in: -10...10) // Adjust the x-impulse range as needed
//        
//        // Example: Adjust y-impulse based on the desired y-positions
//        var impulseY: CGFloat = 0.0
//        let randomY = CGFloat.random(in: 100...300) // Adjust the y-position range as needed
//        let deltaY = randomY - spawnY
//        let timeToReachY = sqrt(2 * abs(deltaY) / 9.8)
//        impulseY = deltaY / timeToReachY
//        
//        item.physicsBody = SKPhysicsBody(rectangleOf: item.size)
//        item.physicsBody?.categoryBitMask = 1
//        item.physicsBody?.allowsRotation = true
//        item.physicsBody?.contactTestBitMask = 1
//        item.physicsBody?.collisionBitMask = 0
//        item.physicsBody?.affectedByGravity = true
//        
//        // Apply impulses
//        item.physicsBody?.applyImpulse(CGVector(dx: impulseX, dy: impulseY))
//    }


    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        let distance = abs(touchLocation.x - dog.position.x)
        let duration = TimeInterval(distance / 150)
        
        let moveAction = SKAction.moveTo(x: touchLocation.x, duration: duration)
        dog.run(moveAction)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        enumerateChildNodes(withName: "item") { node, _ in
            if node.frame.intersects(self.dog.frame) {
                if self.collectedItems < 3 {
                    node.removeFromParent()
                    self.collectedItems += 1
                    self.updateItemLabel()
                }
            }
        }
        
        if dog.frame.intersects(basket.frame) && collectedItems > 0 {
            // Pause dog movement while unloading items
            dog.removeAllActions()
            // Simulate unloading time
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.collectedItems = 0
                self.updateItemLabel()
                self.dog.removeAllActions()
//                let moveAction = SKAction.moveTo(x: self.size.width / 2, duration: 0.5)
//                self.dog.run(moveAction)
            }
        }
    }
    
    func updateItemLabel() {
        itemLabel.text = "Items: \(collectedItems)"
    }
}

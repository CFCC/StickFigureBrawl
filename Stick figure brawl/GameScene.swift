//
//  GameScene.swift
//  Stick figure brawl
//
//  Created by Jarrett Bishop on 6/17/15.
//  Copyright (c) 2015 Anti-Hero. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    
    var world = SKNode()
    let hero = SKSpriteNode(imageNamed: "punch1")
    var platform = SKNode()
    let grunts = SKNode()
   var herohealth = 50
    var killedenemies = 0
    let healthbar = SKLabelNode(text: "r")
    let enemieskilled = SKLabelNode(text: "t")
    let fall1 = SKAction.moveTo(CGPoint(x: 1025, y: 197), duration: 2)
    let fall2 = SKAction.moveTo(CGPoint(x: 25, y: 197), duration: 2)
    let fall3 = SKAction.moveTo(CGPoint(x: 1075, y: 197), duration: 2)
    let fall4 = SKAction.moveTo(CGPoint(x: 50, y: 197), duration: 2)
    let backround = SKSpriteNode(imageNamed: "gameover")
    let tryagain = SKSpriteNode(imageNamed: "tryagain")

    
    
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
       world = childNodeWithName("world")!
        platform = world.childNodeWithName("platform")!
        
        startGame()
    }
    
    func startGame() {
        
        hero.texture = SKTexture(imageNamed: "punch1")
        hero.size = hero.texture!.size()
        hero.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.234)
        hero.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        world.addChild(hero)
        world.addChild(grunts)
        addChild(healthbar)
        addChild(enemieskilled)
        

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        if backround.parent != nil {
            world.removeChildrenInArray([grunts, hero])
            hero.removeAllActions()
            grunts.removeAllChildren()
            removeChildrenInArray([enemieskilled, healthbar, backround, tryagain])
            startGame()
        }
    }
    
    func punch() {
        hero.removeActionForKey("running")
        let atlas = SKTextureAtlas(named: "punching")
        let textures = [
            atlas.textureNamed("punch1"),
            atlas.textureNamed("punch2"),
            atlas.textureNamed("punch3"),
            atlas.textureNamed("punch4"),
            atlas.textureNamed("punch5"),
            atlas.textureNamed("punch6"),
            atlas.textureNamed("punch7"),
        
        ]
        let actionAnim = SKAction.animateWithTextures(textures, timePerFrame: 0.05, resize: true, restore: false)
        
        hero.runAction(SKAction.sequence([actionAnim, SKAction.setTexture(SKTexture(imageNamed: "punch1"), resize: true)]))
        
        for grunt in grunts.children {
            if hero.frame .intersects(grunt.frame) {
                grunt.removeFromParent()
                killedenemies = killedenemies+1
                enemieskilled.text = ("ENEMIES KILLED \(killedenemies)")
                enemieskilled.position = CGPoint(x: self.size.width*0.2, y: self.size.height*0.9)
                enemieskilled.zPosition = 17
            }
        }
    }

    func runright() {
        let atlas = SKTextureAtlas(named: "running")
        let textures = [
            atlas.textureNamed("running1"),
            atlas.textureNamed("running2"),
            atlas.textureNamed("running3"),
            atlas.textureNamed("running4"),
            atlas.textureNamed("running5"),
            atlas.textureNamed("running6"),
            atlas.textureNamed("running7"),
            
        ]
        //let actionAnim = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
        let actionAnim = SKAction.animateWithTextures(textures, timePerFrame: 0.08, resize: true, restore: false)
        
        
       
        hero.runAction(SKAction.group([
                SKAction.repeatActionForever(actionAnim),
                SKAction.repeatActionForever(SKAction.moveBy(CGVector(dx: 500, dy: 0), duration: 1))
            ]), withKey: "running")
        hero.xScale = 1
    }


    func runleft() {
        let atlas = SKTextureAtlas(named: "running")
        let textures = [
            atlas.textureNamed("running1"),
            atlas.textureNamed("running2"),
            atlas.textureNamed("running3"),
            atlas.textureNamed("running4"),
            atlas.textureNamed("running5"),
            atlas.textureNamed("running6"),
            atlas.textureNamed("running7"),
            
        ]
        //let actionAnim = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
        let actionAnim = SKAction.animateWithTextures(textures, timePerFrame: 0.08, resize: true, restore: false)
        
        
  
        hero.runAction(SKAction.group([
            SKAction.repeatActionForever(actionAnim),
            SKAction.repeatActionForever(SKAction.moveBy(CGVector(dx: -500, dy: 0), duration: 1))
            ]), withKey: "running")
        hero.xScale = -1
    }


    override func didFinishUpdate() {
       
        
    
        world.position.x = -hero.position.x + self.size.width*0.5
        world.position.y = -hero.position.y + self.size.height*0.2
        if hero.frame .intersects(platform.frame) == false {
            hero.runAction(SKAction.repeatActionForever(SKAction.moveBy(CGVector(dx: 0, dy: -500), duration: 2)))
            showGameOver()

        }
    
        // GRUNT PUNCH SECTION
        for grunt in grunts.children {
            if grunt.frame .intersects(hero.frame) == true {
                
                if grunt.actionForKey("punch") == nil {
                
                    let atlas = SKTextureAtlas(named: "gruntpunch")
                    let textures = [
                        atlas.textureNamed("gruntpunch21"),
                        atlas.textureNamed("gruntpunch22"),
                        atlas.textureNamed("gruntpunch23"),
                        atlas.textureNamed("gruntpunch24"),
                        
                    ]
                    //let actionAnim = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
                    let actionAnim = SKAction.animateWithTextures(textures, timePerFrame: 0.08, resize: true, restore: false)
                    grunt.runAction(SKAction.sequence([SKAction.waitForDuration(0.2), SKAction.runBlock({ () -> Void in
                        self.herohealth = self.herohealth - 1
                        self.healthbar.text = "\(self.herohealth) /50"
                        self.healthbar.position = CGPoint(x: self.size.width*0.87, y: self.size.height*0.9)
                    self.healthbar.zPosition = 4
                    if self.herohealth == 0 {
                   self.hero.removeFromParent()
                   self.healthbar.removeFromParent()
                   self.showGameOver()
                    }
                    }), actionAnim]), withKey: "punch")
                   
                    
                }
            }
        }
        for grunt in grunts.children {
           
            if grunt.actionForKey("punch") == nil {
                if grunt.actionForKey("run") == nil {
                    if grunt.actionForKey("fall") == nil {
        
                        let chase = SKAction.moveTo( hero.position, duration: 2)
                        grunt.runAction(chase)
        
                    let atlas = SKTextureAtlas(named: "gruntrun")
                    let textures = [
                        atlas.textureNamed("gruntrun1"),
                        atlas.textureNamed("gruntrun2"),
                        atlas.textureNamed("gruntrun3"),
                        atlas.textureNamed("gruntrun4"),
                        atlas.textureNamed("gruntrun5"),
                        atlas.textureNamed("gruntrun6"),
                        atlas.textureNamed("gruntrun7"),
                        atlas.textureNamed("gruntrun8"),
                        
                    ]
                    let actionAnim = SKAction.animateWithTextures(textures, timePerFrame: 0.08, resize: true, restore: false)
                    grunt.runAction(actionAnim, withKey: "run")
                    }
                }
            }
        }
        // GRUNT SPAWNING
        if grunts.children.count < 4 {

            let grunt = SKSpriteNode(imageNamed: "gruntpunch21")
            grunt.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            grunts.addChild(grunt)
             
            
            if grunts.children.count == 1 {
                grunt.position = CGPoint(x: 1025, y: 1000)
                grunt.runAction(fall1, withKey: "fall")
                grunt.xScale = -1
            
            }
            
            
            if grunts.children.count == 2{
                grunt.position = CGPoint(x: 25, y: 1000)
                grunt.runAction(fall2, withKey: "fall")
            }
            
            if grunts.children.count == 3{
                grunt.position = CGPoint(x: 925, y: 1000)
                grunt.runAction(fall3, withKey: "fall")
                grunt.xScale = -1
          
            
            }
            
            if grunts.children.count == 4{
                grunt.position = CGPoint(x: 100, y: 1000)
                grunt.runAction(fall4, withKey: "fall")
            }
        }

    }
 
    func showGameOver() {
        if backround.parent == nil {
            backround.position = CGPoint(x: self.size.width*0.5, y: self.size.width*0.38)
            backround.size = CGSize(width: self.size.width, height: self.size.height)
            backround.zPosition = 16
            addChild(backround)
          
            tryagain.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.30)
            tryagain.size = CGSize(width: 200, height: 200)
            tryagain.zPosition = 20
            addChild(tryagain)
            
        }
    }
}








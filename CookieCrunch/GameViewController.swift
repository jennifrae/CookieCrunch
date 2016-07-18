//
//  GameViewController.swift
//  CookieCrunch
//
//  Created by 소프트가족 on 2016. 5. 11..
//  Copyright (c) 2016년 Bloc. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation


class GameViewController: UIViewController {    
    var level: Level!
    var scene: GameScene!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.multipleTouchEnabled = false
        
        // Create and Configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
    
        
        level = Level(filename: "Levels/Level_3")
        scene.level = level
        scene.addTiles()
        gameOverPanel.hidden = false
        
        // Present the Scene
        skView.presentScene(scene)
        
        scene.swipeHandler = handleSwipe
        
        backgroundMusic.play()
        
        beginGame()
    }


    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    
    
    func beginGame() {
        movesLeft = level.maximumMoves
        score = 0
        updateLabels()
        
        level.resetComboMultiplier()
        
        scene.animateBeginGame() {
            self.shuffleButton.hidden = false
        }
        
        shuffle()
    }
    func shuffle() {
        scene.removeAllCookieSprite()
        
        let newCookies = level.shuffle()
        scene.addSpriteForCookies(newCookies)
    }
    
    func handleSwipe(swap: Swap) {
        view.userInteractionEnabled = false
        
        if level.isPossibleSwap(swap) {
            level.performSwap(swap)
            scene.animateSwap(swap, completion: handleMathces)
        } else {
            scene.animateInvalidSwap(swap) {
                self.view.userInteractionEnabled = true
            }
        }
    }
    
    
    func handleMathces() {
        let chains = level.removeMatches()
        
        
        if chains.count == 0 {
            beginNextTurn()
            return
        }
        
        scene.animateMatchedCookies(chains) {
            for chain in chains {
                self.score += chain.score
            }
            self.updateLabels()
            
            var columns = self.level.fillHoles()
            self.scene.animateFallingCookies(columns) {
                columns = self.level.topUpCookies()
                self.scene.animateNewCookies(columns) {
                    self.handleMathces()
                }
            }
        }
    }
    
    func beginNextTurn() {
        level.resetComboMultiplier()
        decrementMove()
        
        level.detectPossibleSwap()
        view.userInteractionEnabled = true
    }
    
    var movesLeft = 0
    var score = 0
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameOverPanel: UIImageView!
    
    @IBOutlet weak var shuffleButton: UIButton!
    @IBAction func shuffleButtonPressed(sender: AnyObject) {
        shuffle()
        decrementMove()
    }
    
    func updateLabels() {
        targetLabel.text = String(format: "%ld", level.targetScore)
        movesLabel.text = String(format: "%ld", movesLeft)
        scoreLabel.text = String(format: "%ld", score)
        
        targetLabel.textColor = UIColor.whiteColor()
        movesLabel.textColor = UIColor.whiteColor()
        scoreLabel.textColor = UIColor.whiteColor()
    }
    
    func decrementMove() {
        movesLeft -= 1
        updateLabels()
        
        if score >= level.targetScore {
            gameOverPanel.image = UIImage(named: "LevelComplete")
            showGameOver()
        }
        else if movesLeft == 0 {
            gameOverPanel.image = UIImage(named: "GameOver")
            showGameOver()
        }
    }
    
    func showGameOver() {
        gameOverPanel.hidden = false
        scene.userInteractionEnabled = false
        
        scene.animateGameOver() {
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameViewController.hideGameOver))
            self.view.addGestureRecognizer(self.tapGestureRecognizer)
        }
    }
    
    func hideGameOver() {
        view.removeGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = nil
        
        gameOverPanel.hidden = true
        scene.userInteractionEnabled = true
        
        shuffleButton.hidden = true
        
        beginGame()
    }
    
    
    lazy var backgroundMusic: AVAudioPlayer = {
        let url = NSBundle.mainBundle().URLForResource("Mining by Moonlight", withExtension: "mp3")
        let player = try? AVAudioPlayer(contentsOfURL: url!)
        player!.numberOfLoops = -1
        return player!
    }()
}

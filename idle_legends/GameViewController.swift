//
//  GameViewController.swift
//  idle_legends
//
//  Created by pedro santilli on 10/07/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and present the MenuScene as the initial scene
        if let view = self.view as! SKView? {
            // Create the menu scene
            let menuScene = MenuScene(size: view.bounds.size)
            menuScene.scaleMode = .aspectFill
            
            // Present the menu scene
            view.presentScene(menuScene)
            
            view.ignoresSiblingOrder = true
            
            // Show FPS and node count for debugging (can be removed in production)
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

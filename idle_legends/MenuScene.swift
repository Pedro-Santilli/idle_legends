//
//  MenuScene.swift
//  idle_legends
//
//  Created by AI Assistant on 11/07/25.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    // MARK: - UI Elements
    private var backgroundNode: SKSpriteNode?
    private var logoNode: SKSpriteNode?
    private var startGameButton: SKLabelNode?
    private var continueButton: SKLabelNode?
    private var settingsButton: SKLabelNode?
    private var creditsButton: SKLabelNode?
    private var tipLabel: SKLabelNode?
    
    // MARK: - Animation Properties
    private var logoAnimation: SKAction?
    private var backgroundAnimation: SKAction?
    
    // MARK: - Game Data
    private let gameplayTips = [
        "Purifique o Véu para restaurar a vida.",
        "Fragmentos escondem a história esquecida.",
        "A Ordem dos Quatro Caminhos guia seu destino.",
        "Explore as sombras para encontrar a luz.",
        "Cada escolha molda o futuro do reino.",
        "Os cristais místicos amplificam seu poder.",
        "Medite para fortalecer sua conexão espiritual."
    ]
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupLogo()
        setupButtons()
        setupGameplayTip()
        startAnimations()
        
        // Start background music
        SoundManager.shared.playBackgroundMusic(named: "menu_background")
    }
    
    // MARK: - Setup Methods
    
    private func setupBackground() {
        // Create animated background representing the Shadow Veil
        backgroundNode = SKSpriteNode(color: .systemPurple, size: self.size)
        backgroundNode?.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundNode?.zPosition = -1
        
        // Add mystical gradient effect
        let gradient = SKTexture(image: createGradientImage())
        backgroundNode?.texture = gradient
        
        self.addChild(backgroundNode!)
    }
    
    private func setupLogo() {
        // Create the mystical logo for "Ordem dos Quatro Caminhos"
        logoNode = SKSpriteNode(color: .systemGold, size: CGSize(width: 200, height: 80))
        logoNode?.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
        logoNode?.zPosition = 1
        
        // Add logo text (placeholder - would be replaced with actual logo image)
        let logoText = SKLabelNode(text: "IDLE LEGENDS")
        logoText.fontName = "HelveticaNeue-Bold"
        logoText.fontSize = 24
        logoText.fontColor = .black
        logoText.position = CGPoint.zero
        logoNode?.addChild(logoText)
        
        let subtitleText = SKLabelNode(text: "Ordem dos Quatro Caminhos")
        subtitleText.fontName = "HelveticaNeue-Light"
        subtitleText.fontSize = 12
        subtitleText.fontColor = .black
        subtitleText.position = CGPoint(x: 0, y: -20)
        logoNode?.addChild(subtitleText)
        
        self.addChild(logoNode!)
    }
    
    private func setupButtons() {
        let buttonSpacing: CGFloat = 60
        let buttonStartY = self.frame.midY - 50
        
        // Start Game Button
        startGameButton = createMenuButton(text: "INICIAR JOGO", 
                                         position: CGPoint(x: self.frame.midX, y: buttonStartY))
        
        // Continue Button
        continueButton = createMenuButton(text: "CONTINUAR", 
                                        position: CGPoint(x: self.frame.midX, y: buttonStartY - buttonSpacing))
        
        // Settings Button
        settingsButton = createMenuButton(text: "CONFIGURAÇÕES", 
                                        position: CGPoint(x: self.frame.midX, y: buttonStartY - buttonSpacing * 2))
        
        // Credits Button
        creditsButton = createMenuButton(text: "CRÉDITOS", 
                                       position: CGPoint(x: self.frame.midX, y: buttonStartY - buttonSpacing * 3))
        
        // Add all buttons to scene
        [startGameButton, continueButton, settingsButton, creditsButton].forEach { button in
            if let button = button {
                self.addChild(button)
            }
        }
    }
    
    private func createMenuButton(text: String, position: CGPoint) -> SKLabelNode {
        let button = SKLabelNode(text: text)
        button.fontName = "HelveticaNeue-Medium"
        button.fontSize = 18
        button.fontColor = .systemGold
        button.position = position
        button.zPosition = 2
        
        // Add background for button
        let background = SKShapeNode(rectOf: CGSize(width: 250, height: 40), cornerRadius: 8)
        background.fillColor = UIColor.systemPurple.withAlphaComponent(0.8)
        background.strokeColor = .systemGold
        background.lineWidth = 2
        background.zPosition = -1
        button.addChild(background)
        
        return button
    }
    
    private func setupGameplayTip() {
        tipLabel = SKLabelNode(text: getRandomTip())
        tipLabel?.fontName = "HelveticaNeue-Light"
        tipLabel?.fontSize = 14
        tipLabel?.fontColor = .lightGray
        tipLabel?.position = CGPoint(x: self.frame.midX, y: 50)
        tipLabel?.zPosition = 2
        
        // Add quotation marks for style
        tipLabel?.text = "\" \(tipLabel?.text ?? "") \""
        
        self.addChild(tipLabel!)
    }
    
    // MARK: - Animation Methods
    
    private func startAnimations() {
        setupLogoAnimation()
        setupBackgroundAnimation()
    }
    
    private func setupLogoAnimation() {
        // Create pulsing animation for logo
        let scaleUp = SKAction.scale(to: 1.1, duration: 1.0)
        let scaleDown = SKAction.scale(to: 1.0, duration: 1.0)
        scaleUp.timingMode = .easeInEaseOut
        scaleDown.timingMode = .easeInEaseOut
        
        logoAnimation = SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown]))
        logoNode?.run(logoAnimation!)
    }
    
    private func setupBackgroundAnimation() {
        // Create subtle background animation (breathing effect)
        let fadeIn = SKAction.fadeAlpha(to: 0.9, duration: 3.0)
        let fadeOut = SKAction.fadeAlpha(to: 0.7, duration: 3.0)
        fadeIn.timingMode = .easeInEaseOut
        fadeOut.timingMode = .easeInEaseOut
        
        backgroundAnimation = SKAction.repeatForever(SKAction.sequence([fadeIn, fadeOut]))
        backgroundNode?.run(backgroundAnimation!)
    }
    
    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        handleButtonTouch(touchedNode)
    }
    
    private func handleButtonTouch(_ node: SKNode) {
        // Play button click sound
        SoundManager.shared.playButtonClickSound()
        
        // Animate button press
        let scaleDown = SKAction.scale(to: 0.95, duration: 0.1)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        let buttonPress = SKAction.sequence([scaleDown, scaleUp])
        
        switch node {
        case startGameButton:
            startGameButton?.run(buttonPress)
            startNewGame()
            
        case continueButton:
            continueButton?.run(buttonPress)
            continueGame()
            
        case settingsButton:
            settingsButton?.run(buttonPress)
            openSettings()
            
        case creditsButton:
            creditsButton?.run(buttonPress)
            showCredits()
            
        default:
            break
        }
    }
    
    // MARK: - Navigation Methods
    
    private func startNewGame() {
        // Play transition sound
        SoundManager.shared.playMenuTransitionSound()
        
        // Navigate to character creation or game scene
        print("Starting new game...")
        
        // For now, transition to the existing GameScene
        let gameScene = GameScene(fileNamed: "GameScene")
        gameScene?.scaleMode = .aspectFill
        
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(gameScene!, transition: transition)
    }
    
    private func continueGame() {
        // Load saved game data
        print("Continuing game...")
        
        // Check if save data exists using GameState
        if GameState.shared.hasSavedProgress() {
            if let progress = GameState.shared.loadGameProgress() {
                print("Loading game - Level: \(progress.playerLevel), Location: \(progress.currentLocation)")
                // Load the game with saved progress
                startGameWithProgress(progress)
            } else {
                showNoSaveDataMessage()
            }
        } else {
            // Show message that no save data exists
            showNoSaveDataMessage()
        }
    }
    
    private func openSettings() {
        // Open settings menu
        print("Opening settings...")
        
        let settingsScene = SettingsScene(size: self.size)
        settingsScene.scaleMode = .aspectFill
        
        let transition = SKTransition.moveIn(with: .right, duration: 0.5)
        self.view?.presentScene(settingsScene, transition: transition)
    }
    
    private func showCredits() {
        // Show credits
        print("Showing credits...")
        
        let creditsScene = CreditsScene(size: self.size)
        creditsScene.scaleMode = .aspectFill
        
        let transition = SKTransition.moveIn(with: .up, duration: 0.5)
        self.view?.presentScene(creditsScene, transition: transition)
    }
    
    // MARK: - Helper Methods
    
    private func getRandomTip() -> String {
        return gameplayTips.randomElement() ?? "Explore o mundo misterioso que te aguarda."
    }
    
    private func startGameWithProgress(_ progress: GameState.GameProgress) {
        // Navigate to game scene with loaded progress
        print("Starting game with progress: Level \(progress.playerLevel)")
        
        // For now, transition to the existing GameScene
        // In a full implementation, this would pass the progress data
        let gameScene = GameScene(fileNamed: "GameScene")
        gameScene?.scaleMode = .aspectFill
        
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(gameScene!, transition: transition)
    }
    
    private func hasSaveData() -> Bool {
        // Use GameState to check for save data
        return GameState.shared.hasSavedProgress()
    }
    
    private func showNoSaveDataMessage() {
        // Play error sound
        SoundManager.shared.playErrorSound()
        
        let messageLabel = SKLabelNode(text: "Nenhum progresso salvo encontrado")
        messageLabel.fontName = "HelveticaNeue-Light"
        messageLabel.fontSize = 16
        messageLabel.fontColor = .red
        messageLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 250)
        messageLabel.zPosition = 10
        
        // Add fade in/out animation
        messageLabel.alpha = 0
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let wait = SKAction.wait(forDuration: 2.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        
        messageLabel.run(SKAction.sequence([fadeIn, wait, fadeOut, remove]))
        self.addChild(messageLabel)
    }
    
    private func createGradientImage() -> UIImage {
        let size = CGSize(width: 100, height: 100)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let colors = [UIColor.systemPurple.cgColor, UIColor.systemIndigo.cgColor]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: nil)!
            
            context.cgContext.drawLinearGradient(gradient, 
                                               start: CGPoint(x: 0, y: 0), 
                                               end: CGPoint(x: size.width, y: size.height), 
                                               options: [])
        }
    }
}
//
//  SettingsScene.swift
//  idle_legends
//
//  Created by AI Assistant on 11/07/25.
//

import SpriteKit

class SettingsScene: SKScene {
    
    // MARK: - UI Elements
    private var titleLabel: SKLabelNode?
    private var musicToggleButton: SKLabelNode?
    private var soundToggleButton: SKLabelNode?
    private var languageButton: SKLabelNode?
    private var autoSaveToggleButton: SKLabelNode?
    private var backButton: SKLabelNode?
    
    // MARK: - Settings State
    private var settings: GameState.GameSettings
    
    override init(size: CGSize) {
        self.settings = GameState.shared.loadGameSettings()
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.settings = GameState.shared.loadGameSettings()
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupSettingsButtons()
        setupBackButton()
    }
    
    // MARK: - Setup Methods
    
    private func setupBackground() {
        // Create similar background to menu scene
        let backgroundNode = SKSpriteNode(color: UIColor.systemPurple.withAlphaComponent(0.3), size: self.size)
        backgroundNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundNode.zPosition = -1
        self.addChild(backgroundNode)
    }
    
    private func setupTitle() {
        titleLabel = SKLabelNode(text: "CONFIGURAÇÕES")
        titleLabel?.fontName = "HelveticaNeue-Bold"
        titleLabel?.fontSize = 24
        titleLabel?.fontColor = .systemGold
        titleLabel?.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 200)
        titleLabel?.zPosition = 1
        
        self.addChild(titleLabel!)
    }
    
    private func setupSettingsButtons() {
        let buttonSpacing: CGFloat = 60
        let startY = self.frame.midY + 100
        
        // Music Toggle
        musicToggleButton = createSettingButton(
            text: "Música: \(settings.musicEnabled ? "LIGADA" : "DESLIGADA")",
            position: CGPoint(x: self.frame.midX, y: startY)
        )
        
        // Sound Effects Toggle
        soundToggleButton = createSettingButton(
            text: "Efeitos Sonoros: \(settings.soundEffectsEnabled ? "LIGADOS" : "DESLIGADOS")",
            position: CGPoint(x: self.frame.midX, y: startY - buttonSpacing)
        )
        
        // Language
        languageButton = createSettingButton(
            text: "Idioma: \(getLanguageDisplayName(settings.language))",
            position: CGPoint(x: self.frame.midX, y: startY - buttonSpacing * 2)
        )
        
        // Auto Save
        autoSaveToggleButton = createSettingButton(
            text: "Salvamento Automático: \(settings.autoSaveEnabled ? "LIGADO" : "DESLIGADO")",
            position: CGPoint(x: self.frame.midX, y: startY - buttonSpacing * 3)
        )
        
        // Add all buttons to scene
        [musicToggleButton, soundToggleButton, languageButton, autoSaveToggleButton].forEach { button in
            if let button = button {
                self.addChild(button)
            }
        }
    }
    
    private func setupBackButton() {
        backButton = createSettingButton(
            text: "VOLTAR",
            position: CGPoint(x: self.frame.midX, y: self.frame.midY - 200)
        )
        backButton?.fontColor = .systemRed
        
        self.addChild(backButton!)
    }
    
    private func createSettingButton(text: String, position: CGPoint) -> SKLabelNode {
        let button = SKLabelNode(text: text)
        button.fontName = "HelveticaNeue-Medium"
        button.fontSize = 16
        button.fontColor = .white
        button.position = position
        button.zPosition = 2
        
        // Add background for button
        let background = SKShapeNode(rectOf: CGSize(width: 350, height: 40), cornerRadius: 8)
        background.fillColor = UIColor.systemIndigo.withAlphaComponent(0.6)
        background.strokeColor = .systemGold
        background.lineWidth = 1
        background.zPosition = -1
        button.addChild(background)
        
        return button
    }
    
    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        handleSettingTouch(touchedNode)
    }
    
    private func handleSettingTouch(_ node: SKNode) {
        SoundManager.shared.playButtonClickSound()
        
        // Animate button press
        let scaleDown = SKAction.scale(to: 0.95, duration: 0.1)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        let buttonPress = SKAction.sequence([scaleDown, scaleUp])
        
        switch node {
        case musicToggleButton:
            musicToggleButton?.run(buttonPress)
            toggleMusic()
            
        case soundToggleButton:
            soundToggleButton?.run(buttonPress)
            toggleSoundEffects()
            
        case languageButton:
            languageButton?.run(buttonPress)
            toggleLanguage()
            
        case autoSaveToggleButton:
            autoSaveToggleButton?.run(buttonPress)
            toggleAutoSave()
            
        case backButton:
            backButton?.run(buttonPress)
            goBack()
            
        default:
            break
        }
    }
    
    // MARK: - Settings Actions
    
    private func toggleMusic() {
        settings.musicEnabled.toggle()
        SoundManager.shared.setMusicEnabled(settings.musicEnabled)
        musicToggleButton?.text = "Música: \(settings.musicEnabled ? "LIGADA" : "DESLIGADA")"
        saveSettings()
    }
    
    private func toggleSoundEffects() {
        settings.soundEffectsEnabled.toggle()
        SoundManager.shared.setSoundEffectsEnabled(settings.soundEffectsEnabled)
        soundToggleButton?.text = "Efeitos Sonoros: \(settings.soundEffectsEnabled ? "LIGADOS" : "DESLIGADOS")"
        saveSettings()
    }
    
    private func toggleLanguage() {
        // Cycle through available languages
        let languages = ["pt-BR", "en-US", "es-ES"]
        if let currentIndex = languages.firstIndex(of: settings.language) {
            let nextIndex = (currentIndex + 1) % languages.count
            settings.language = languages[nextIndex]
        } else {
            settings.language = "pt-BR"
        }
        
        languageButton?.text = "Idioma: \(getLanguageDisplayName(settings.language))"
        saveSettings()
    }
    
    private func toggleAutoSave() {
        settings.autoSaveEnabled.toggle()
        autoSaveToggleButton?.text = "Salvamento Automático: \(settings.autoSaveEnabled ? "LIGADO" : "DESLIGADO")"
        saveSettings()
    }
    
    private func goBack() {
        // Return to menu scene
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .aspectFill
        
        let transition = SKTransition.moveIn(with: .left, duration: 0.5)
        self.view?.presentScene(menuScene, transition: transition)
    }
    
    // MARK: - Helper Methods
    
    private func saveSettings() {
        GameState.shared.saveGameSettings(settings)
    }
    
    private func getLanguageDisplayName(_ languageCode: String) -> String {
        switch languageCode {
        case "pt-BR":
            return "Português"
        case "en-US":
            return "English"
        case "es-ES":
            return "Español"
        default:
            return "Português"
        }
    }
}
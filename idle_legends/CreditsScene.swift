//
//  CreditsScene.swift
//  idle_legends
//
//  Created by AI Assistant on 11/07/25.
//

import SpriteKit

class CreditsScene: SKScene {
    
    private var backButton: SKLabelNode?
    private var scrollNode: SKNode?
    private var creditsContent: [String] = []
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupCreditsContent()
        setupScrollingCredits()
        setupBackButton()
    }
    
    private func setupBackground() {
        let backgroundNode = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.8), size: self.size)
        backgroundNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundNode.zPosition = -1
        self.addChild(backgroundNode)
    }
    
    private func setupCreditsContent() {
        creditsContent = [
            "",
            "IDLE LEGENDS",
            "Ordem dos Quatro Caminhos",
            "",
            "═══════════════════════",
            "",
            "DESENVOLVIMENTO",
            "Pedro Santilli",
            "",
            "DESIGN DE JOGO",
            "Equipe de Desenvolvimento",
            "",
            "ARTE E VISUAL",
            "Artistas Conceituais",
            "",
            "ÁUDIO E MÚSICA",
            "Compositores",
            "",
            "═══════════════════════",
            "",
            "HISTÓRIA E LORE",
            "",
            "Em um reino onde o Véu Sombrio",
            "ameaça consumir toda a vida,",
            "a antiga Ordem dos Quatro Caminhos",
            "resurge para restaurar o equilíbrio.",
            "",
            "Cada caminho representa uma filosofia:",
            "• Força - O poder da determinação",
            "• Sabedoria - O conhecimento ancestral", 
            "• Harmonia - O equilíbrio natural",
            "• Transcendência - A superação dos limites",
            "",
            "Unidos, estes caminhos podem",
            "purificar o Véu e trazer",
            "a paz de volta ao mundo.",
            "",
            "═══════════════════════",
            "",
            "AGRADECIMENTOS ESPECIAIS",
            "",
            "À comunidade de jogadores",
            "que acreditou nesta jornada.",
            "",
            "Aos beta testers que ajudaram",
            "a moldar esta experiência.",
            "",
            "E a todos que embarcaram",
            "nesta aventura mística.",
            "",
            "═══════════════════════",
            "",
            "Versão 1.0",
            "© 2025 Idle Legends",
            "",
            "Feito com ❤️ e magia",
            "",
            ""
        ]
    }
    
    private func setupScrollingCredits() {
        scrollNode = SKNode()
        scrollNode?.position = CGPoint(x: self.frame.midX, y: -100)
        self.addChild(scrollNode!)
        
        var currentY: CGFloat = 0
        
        for (index, line) in creditsContent.enumerated() {
            let label = SKLabelNode(text: line)
            
            // Style different types of content
            if line.contains("═══") {
                // Separator line
                label.fontName = "HelveticaNeue-Light"
                label.fontSize = 14
                label.fontColor = .systemGold
            } else if line == "IDLE LEGENDS" {
                // Main title
                label.fontName = "HelveticaNeue-Bold"
                label.fontSize = 28
                label.fontColor = .systemGold
            } else if line == "Ordem dos Quatro Caminhos" {
                // Subtitle
                label.fontName = "HelveticaNeue-Medium"
                label.fontSize = 16
                label.fontColor = .systemGold
            } else if line.uppercased() == line && !line.isEmpty && !line.contains("═") {
                // Section headers
                label.fontName = "HelveticaNeue-Bold"
                label.fontSize = 18
                label.fontColor = .white
            } else if line.hasPrefix("•") {
                // Bullet points
                label.fontName = "HelveticaNeue-Light"
                label.fontSize = 14
                label.fontColor = .systemPurple
            } else {
                // Regular content
                label.fontName = "HelveticaNeue-Light"
                label.fontSize = 14
                label.fontColor = .lightGray
            }
            
            label.position = CGPoint(x: 0, y: currentY)
            label.zPosition = 1
            scrollNode?.addChild(label)
            
            currentY += 30 // Line spacing
        }
        
        // Start scrolling animation
        startScrolling()
    }
    
    private func startScrolling() {
        let totalHeight = CGFloat(creditsContent.count * 30)
        let scrollDistance = totalHeight + self.frame.height + 200
        let scrollDuration = TimeInterval(scrollDistance / 50) // 50 points per second
        
        let scrollAction = SKAction.moveBy(x: 0, y: scrollDistance, duration: scrollDuration)
        let resetAction = SKAction.moveBy(x: 0, y: -scrollDistance, duration: 0)
        let waitAction = SKAction.wait(forDuration: 2.0)
        
        let sequence = SKAction.sequence([scrollAction, waitAction, resetAction])
        let repeatAction = SKAction.repeatForever(sequence)
        
        scrollNode?.run(repeatAction)
    }
    
    private func setupBackButton() {
        backButton = SKLabelNode(text: "VOLTAR")
        backButton?.fontName = "HelveticaNeue-Bold"
        backButton?.fontSize = 18
        backButton?.fontColor = .systemRed
        backButton?.position = CGPoint(x: self.frame.midX, y: 50)
        backButton?.zPosition = 10
        
        // Add background for button
        let background = SKShapeNode(rectOf: CGSize(width: 120, height: 40), cornerRadius: 8)
        background.fillColor = UIColor.black.withAlphaComponent(0.7)
        background.strokeColor = .systemRed
        background.lineWidth = 2
        background.zPosition = -1
        backButton?.addChild(background)
        
        self.addChild(backButton!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        if touchedNode == backButton {
            SoundManager.shared.playButtonClickSound()
            
            // Animate button press
            let scaleDown = SKAction.scale(to: 0.95, duration: 0.1)
            let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
            let buttonPress = SKAction.sequence([scaleDown, scaleUp])
            
            backButton?.run(buttonPress) {
                self.goBack()
            }
        }
    }
    
    private func goBack() {
        // Return to menu scene
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .aspectFill
        
        let transition = SKTransition.moveIn(with: .left, duration: 0.5)
        self.view?.presentScene(menuScene, transition: transition)
    }
}
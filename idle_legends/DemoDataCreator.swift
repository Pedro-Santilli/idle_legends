//
//  DemoDataCreator.swift
//  idle_legends
//
//  Created by AI Assistant on 11/07/25.
//

import Foundation

class DemoDataCreator {
    
    static func createDemoSaveData() {
        var progress = GameState.GameProgress()
        progress.playerLevel = 5
        progress.currentLocation = "Floresta Sombria"
        progress.questsCompleted = ["Tutorial", "Primeira Purificação", "Encontro com o Guardião"]
        progress.itemsCollected = ["Cristal da Harmonia", "Pergaminho Antigo", "Fragmento do Véu"]
        progress.gameTimeSeconds = 3600 // 1 hour of gameplay
        progress.lastSaveDate = Date()
        
        GameState.shared.saveGameProgress(progress)
        GameState.shared.savePlayerName("Guardião Iniciante")
        
        print("Demo save data created successfully!")
    }
    
    static func clearDemoData() {
        GameState.shared.deleteGameProgress()
        print("Demo data cleared!")
    }
}
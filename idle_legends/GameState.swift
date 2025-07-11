//
//  GameState.swift
//  idle_legends
//
//  Created by AI Assistant on 11/07/25.
//

import Foundation

class GameState {
    static let shared = GameState()
    
    private let userDefaults = UserDefaults.standard
    private let gameProgressKey = "gameProgress"
    private let playerNameKey = "playerName"
    private let gameSettingsKey = "gameSettings"
    
    // MARK: - Game Progress
    
    struct GameProgress: Codable {
        var playerLevel: Int
        var currentLocation: String
        var questsCompleted: [String]
        var itemsCollected: [String]
        var gameTimeSeconds: TimeInterval
        var lastSaveDate: Date
        
        init() {
            self.playerLevel = 1
            self.currentLocation = "Santuário"
            self.questsCompleted = []
            self.itemsCollected = []
            self.gameTimeSeconds = 0
            self.lastSaveDate = Date()
        }
    }
    
    struct GameSettings: Codable {
        var musicEnabled: Bool
        var soundEffectsEnabled: Bool
        var language: String
        var autoSaveEnabled: Bool
        
        init() {
            self.musicEnabled = true
            self.soundEffectsEnabled = true
            self.language = "pt-BR"
            self.autoSaveEnabled = true
        }
    }
    
    private init() {}
    
    // MARK: - Save/Load Game Progress
    
    func saveGameProgress(_ progress: GameProgress) {
        if let encoded = try? JSONEncoder().encode(progress) {
            userDefaults.set(encoded, forKey: gameProgressKey)
            userDefaults.synchronize()
            print("Game progress saved successfully")
        } else {
            print("Failed to save game progress")
        }
    }
    
    func loadGameProgress() -> GameProgress? {
        guard let data = userDefaults.data(forKey: gameProgressKey),
              let progress = try? JSONDecoder().decode(GameProgress.self, from: data) else {
            print("No saved game progress found")
            return nil
        }
        
        print("Game progress loaded successfully")
        return progress
    }
    
    func hasSavedProgress() -> Bool {
        return userDefaults.data(forKey: gameProgressKey) != nil
    }
    
    func deleteGameProgress() {
        userDefaults.removeObject(forKey: gameProgressKey)
        userDefaults.synchronize()
        print("Game progress deleted")
    }
    
    // MARK: - Game Settings
    
    func saveGameSettings(_ settings: GameSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            userDefaults.set(encoded, forKey: gameSettingsKey)
            userDefaults.synchronize()
            print("Game settings saved successfully")
        } else {
            print("Failed to save game settings")
        }
    }
    
    func loadGameSettings() -> GameSettings {
        guard let data = userDefaults.data(forKey: gameSettingsKey),
              let settings = try? JSONDecoder().decode(GameSettings.self, from: data) else {
            print("No saved settings found, using defaults")
            return GameSettings()
        }
        
        print("Game settings loaded successfully")
        return settings
    }
    
    // MARK: - Player Data
    
    func savePlayerName(_ name: String) {
        userDefaults.set(name, forKey: playerNameKey)
        userDefaults.synchronize()
    }
    
    func loadPlayerName() -> String? {
        return userDefaults.string(forKey: playerNameKey)
    }
    
    // MARK: - Helper Methods
    
    func createNewGameProgress() -> GameProgress {
        return GameProgress()
    }
    
    func getGameDurationString(from seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    func formatSaveDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
    }
}
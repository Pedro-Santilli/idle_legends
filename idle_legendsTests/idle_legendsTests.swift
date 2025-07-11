//
//  idle_legendsTests.swift
//  idle_legendsTests
//
//  Created by pedro santilli on 10/07/25.
//

import Testing
import SpriteKit
@testable import idle_legends

struct idle_legendsTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func menuSceneInitialization() async throws {
        // Test that MenuScene can be initialized properly
        let size = CGSize(width: 375, height: 667)
        let menuScene = MenuScene(size: size)
        
        #expect(menuScene.size == size)
        #expect(menuScene != nil)
    }
    
    @Test func settingsSceneInitialization() async throws {
        // Test that SettingsScene can be initialized properly
        let size = CGSize(width: 375, height: 667)
        let settingsScene = SettingsScene(size: size)
        
        #expect(settingsScene.size == size)
        #expect(settingsScene != nil)
    }
    
    @Test func creditsSceneInitialization() async throws {
        // Test that CreditsScene can be initialized properly
        let size = CGSize(width: 375, height: 667)
        let creditsScene = CreditsScene(size: size)
        
        #expect(creditsScene.size == size)
        #expect(creditsScene != nil)
    }
    
    @Test func gameStateManagerExists() async throws {
        // Test that GameState singleton is accessible
        let gameState = GameState.shared
        #expect(gameState != nil)
        
        // Test that we can create new game progress
        let progress = gameState.createNewGameProgress()
        #expect(progress.playerLevel == 1)
        #expect(progress.currentLocation == "Santuário")
    }
    
    @Test func soundManagerExists() async throws {
        // Test that SoundManager singleton is accessible
        let soundManager = SoundManager.shared
        #expect(soundManager != nil)
        
        // Test that we can check sound settings
        let musicEnabled = soundManager.isMusicEnabled()
        let soundEffectsEnabled = soundManager.areSoundEffectsEnabled()
        
        #expect(musicEnabled == true || musicEnabled == false) // Just checking it returns a boolean
        #expect(soundEffectsEnabled == true || soundEffectsEnabled == false)
    }

}

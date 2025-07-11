//
//  SoundManager.swift
//  idle_legends
//
//  Created by AI Assistant on 11/07/25.
//

import AVFoundation
import SpriteKit
import AudioToolbox

class SoundManager {
    static let shared = SoundManager()
    
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var soundEffectsEnabled = true
    private var musicEnabled = true
    
    private init() {
        setupAudioSession()
        loadSettings()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func loadSettings() {
        let settings = GameState.shared.loadGameSettings()
        self.musicEnabled = settings.musicEnabled
        self.soundEffectsEnabled = settings.soundEffectsEnabled
    }
    
    // MARK: - Background Music
    
    func playBackgroundMusic(named fileName: String, withExtension ext: String = "mp3") {
        guard musicEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: ext) else {
            print("Could not find audio file: \(fileName).\(ext)")
            return
        }
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1 // Loop indefinitely
            backgroundMusicPlayer?.volume = 0.3
            backgroundMusicPlayer?.play()
            print("Started playing background music: \(fileName)")
        } catch {
            print("Error playing background music: \(error)")
        }
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }
    
    func pauseBackgroundMusic() {
        backgroundMusicPlayer?.pause()
    }
    
    func resumeBackgroundMusic() {
        guard musicEnabled else { return }
        backgroundMusicPlayer?.play()
    }
    
    func setMusicVolume(_ volume: Float) {
        backgroundMusicPlayer?.volume = max(0.0, min(1.0, volume))
    }
    
    // MARK: - Sound Effects
    
    func playSoundEffect(named fileName: String, withExtension ext: String = "wav") {
        guard soundEffectsEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: ext) else {
            print("Could not find sound effect: \(fileName).\(ext)")
            // For now, create a placeholder system sound
            playSystemSound()
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = 0.7
            player.play()
            print("Played sound effect: \(fileName)")
        } catch {
            print("Error playing sound effect: \(error)")
            playSystemSound()
        }
    }
    
    private func playSystemSound() {
        // Fallback to system sound when audio files are not available
        AudioServicesPlaySystemSound(1104) // Navigation click sound
    }
    
    // MARK: - Menu Specific Sounds
    
    func playButtonClickSound() {
        playSoundEffect(named: "button_click")
    }
    
    func playMenuTransitionSound() {
        playSoundEffect(named: "menu_transition")
    }
    
    func playErrorSound() {
        playSoundEffect(named: "error_sound")
    }
    
    func playSuccessSound() {
        playSoundEffect(named: "success_sound")
    }
    
    // MARK: - Settings
    
    func setMusicEnabled(_ enabled: Bool) {
        musicEnabled = enabled
        if enabled {
            resumeBackgroundMusic()
        } else {
            pauseBackgroundMusic()
        }
        
        // Save setting
        var settings = GameState.shared.loadGameSettings()
        settings.musicEnabled = enabled
        GameState.shared.saveGameSettings(settings)
    }
    
    func setSoundEffectsEnabled(_ enabled: Bool) {
        soundEffectsEnabled = enabled
        
        // Save setting
        var settings = GameState.shared.loadGameSettings()
        settings.soundEffectsEnabled = enabled
        GameState.shared.saveGameSettings(settings)
    }
    
    func isMusicEnabled() -> Bool {
        return musicEnabled
    }
    
    func areSoundEffectsEnabled() -> Bool {
        return soundEffectsEnabled
    }
}

// MARK: - SpriteKit Integration

extension SKAction {
    static func playSoundEffect(named fileName: String) -> SKAction {
        return SKAction.playSoundFileNamed("\(fileName).wav", waitForCompletion: false)
    }
}
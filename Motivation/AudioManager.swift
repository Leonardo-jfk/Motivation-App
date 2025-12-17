//
//  AudioManager.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 17/12/2025.
//

import Foundation
import AVFAudio
import SwiftUI
import Combine

@MainActor
final class AudioManager: ObservableObject {
    static let shared = AudioManager()

    // Persisted user preference (shared with SettingsList via the same key)
   @Published var musicEnabled: Bool =  UserDefaults.standard.bool(forKey: "musicEnabled")
    {
        didSet {
            // Persist to UserDefaults so @AppStorage in SettingsList stays in sync
            UserDefaults.standard.set(musicEnabled, forKey: "musicEnabled")

            // Apply immediately
            if musicEnabled {
                startBackgroundMusicIfNeeded()
            } else {
                stopBackgroundMusic()
            }
        }
    }
    // NEW: Volume control (0.0 to 1.0)
//      @Published var musicVolume: Float {
//          didSet {
//              player?.volume = musicVolume
//              UserDefaults.standard.set(musicVolume, forKey: "musicVolume")
//          }
//      }
    private var player: AVAudioPlayer?

    private init() {
        // Load initial value from UserDefaults (defaults to true if not set)
        self.musicEnabled = UserDefaults.standard.object(forKey: "musicEnabled") as? Bool ?? true
        // Apply current preference on creation
        if musicEnabled {
            startBackgroundMusicIfNeeded()
        }
   }

    // Expose a method to be called when toggle changes from elsewhere, if needed.
    func setMusicEnabled(_ enabled: Bool) {
        // Setting the property triggers didSet which persists and applies changes
        musicEnabled = enabled
    }

    // MARK: - Playback

    private func startBackgroundMusicIfNeeded() {
        // If already playing, do nothing
        if let player, player.isPlaying { return }

        guard let url = Bundle.main.url(forResource: "BackWitcher", withExtension: "mp3") else {
            // If your file has a different name or type, adjust above.
            print("AudioManager: BackWitcher.mp3 not found in bundle.")
            return
        }

        do {

            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.numberOfLoops = -1 // loop indefinitely
            newPlayer.prepareToPlay()
            newPlayer.play()
            self.player = newPlayer
        } catch {
            print("AudioManager: Failed to start audio with error: \(error)")
            self.player = nil
        }
    }

    private func stopBackgroundMusic() {
        player?.stop()
        player = nil
    }
}


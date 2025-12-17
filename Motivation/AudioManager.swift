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
//    @Published private(set) var musicEnabled: Bool {
        @Published  var musicEnabled: Bool
    @Published var isMusicEnabled: Bool =  UserDefaults.standard.bool(forKey: "musicEnabled")
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

    private var player: AVAudioPlayer?

    private init() {
        // Load initial value from UserDefaults (defaults to true if not set)
        let initial = UserDefaults.standard.object(forKey: "musicEnabled") as? Bool ?? true
        self.musicEnabled = initial

        // Apply current preference on creation
        if musicEnabled {
            startBackgroundMusicIfNeeded()
        } else {
            stopBackgroundMusic()
        }
    }

    // Call once on app launch (e.g., from MotivationApp) if you prefer explicit configuration
    func configureAndApplyPreference() {
        if musicEnabled {
            startBackgroundMusicIfNeeded()
        } else {
            stopBackgroundMusic()
        }
    }

    // Expose a method to be called when toggle changes from elsewhere, if needed.
    func setMusicEnabled(_ enabled: Bool) {
        // Setting the property triggers didSet which persists and applies changes
        isMusicEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: "musicEnabled")
    }

    // MARK: - Playback

    private func startBackgroundMusicIfNeeded() {
        // If already playing, do nothing
        if let player, player.isPlaying { return }

        guard let url = Bundle.main.url(forResource: "background", withExtension: "mp3") else {
            // If your file has a different name or type, adjust above.
            print("AudioManager: background.mp3 not found in bundle.")
            return
        }

        do {
            // Optional: Set audio session category if you want mixing with other audio
            // try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            // try AVAudioSession.sharedInstance().setActive(true)

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


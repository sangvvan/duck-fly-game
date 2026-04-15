import AVFoundation

class AudioManager {
    static let shared = AudioManager()

    private var audioPlayer: AVAudioPlayer?
    private let soundEffects: [String: String] = [
        "jump": "jump",
        "foodCollect": "pop",
        "combo": "powerup",
        "bossAttack": "hit",
        "playerAttack": "punch",
        "victory": "chime",
        "defeat": "error"
    ]

    private init() {
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.ambient, options: .duckOthers)
            try audioSession.setActive(true)
        } catch {
            print("Audio session setup failed: \(error)")
        }
    }

    func playSound(_ soundName: String) {
        // Since we don't have actual audio files bundled,
        // we'll use system sounds instead
        switch soundName {
        case "jump":
            playSystemSound(1104)  // UIKit pop
        case "foodCollect":
            playSystemSound(1057)  // Alert
        case "combo":
            playSystemSound(1064)  // Power up
        case "bossAttack":
            playSystemSound(1075)  // Hit
        case "playerAttack":
            playSystemSound(1104)  // Pop
        case "victory":
            playSystemSound(1075)  // Success
        case "defeat":
            playSystemSound(1075)  // Alert
        default:
            break
        }
    }

    private func playSystemSound(_ soundID: SystemSoundID) {
        #if os(iOS)
        AudioServicesPlaySystemSound(soundID)
        #endif
    }

    func playSoundIfEnabled(_ soundName: String) {
        let isEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        if isEnabled {
            playSound(soundName)
        }
    }
}

// MARK: - Sound System ID Constants
#if os(iOS)
import UIKit

private func AudioServicesPlaySystemSound(_ soundID: SystemSoundID) {
    AudioServicesPlaySystemSound(soundID)
}

typealias SystemSoundID = UInt32
#endif

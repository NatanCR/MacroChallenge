//
//  AudioManager.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Henrique Assis on 29/05/23.
//

import Foundation
import AVFoundation

class AudioManager : NSObject, AVAudioPlayerDelegate {
    // static vars
    private static let recordedAudioFormat = "m4a"
    
    // audio
    private var audioPlayer: AVAudioPlayer
    
    //MARK: - INIT
    init(audioPlayer: AVAudioPlayer) {
        self.audioPlayer = audioPlayer
    }
    
    //MARK: - PUBLIC METHODS
    /**Plays the audio in the given URL.**/
    public func playAudio(_ audioURL: URL) {
        self.stopAudio()
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            self.prepareAudioPlayer()
            self.audioPlayer.play()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    /**Stops any audio that is reproducing.**/
    public func stopAudio() {
        if !self.audioPlayer.isPlaying {return}
        
        self.audioPlayer.stop()
    }
    
    //MARK: - PRIVATE METHODS
    private func prepareAudioPlayer() {
        self.audioPlayer.delegate = self
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.setVolume(1, fadeDuration: 0)
        self.audioPlayer.numberOfLoops = 0
    }
    
    //MARK: - STATIC FUNCS
    /**Returns the standard format of recorded audios (m4a).**/
    public static func getRecordedAudioFormat() -> String {
        return recordedAudioFormat
    }
}

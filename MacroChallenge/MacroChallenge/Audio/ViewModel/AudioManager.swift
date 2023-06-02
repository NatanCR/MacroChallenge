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
    private var audioPlayer: AVAudioPlayer?
    
    /**assign the AVAudioPlayer to the given URL.*/
    public func assignAudio(_ audioURL: URL) {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: audioURL, fileTypeHint: AVFileType.m4a.rawValue)
            print("assigned")
            self.prepareAudioPlayer()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - REPRODUTION
    /**Plays the audio in the given URL.*/
    public func playAudio(_ audioURL: URL) {
        self.stopAudio()
        
        //if self.audioPlayer == AVAudioPlayer() { self.assignAudio(audioURL) }
        print("play")
        self.audioPlayer?.play()
    }
    
    /**Pauses any audio that is reproducing.*/
    public func pauseAudio() {
        if !(self.audioPlayer?.isPlaying ?? false) { return }
        
        self.audioPlayer?.pause()
    }
    
    /**Stops any audio that is reproducing.*/
    public func stopAudio() {
        if !(self.audioPlayer?.isPlaying ?? false) {return}
        
        self.audioPlayer?.stop()
    }
    
    //MARK: - TIME
    /**Get the current time of an audio that is playing as CGFloat.*/
    public func getCurrentTimeCGFloat() -> CGFloat {
        if !(self.audioPlayer?.isPlaying ?? false) { return CGFloat(0) }
        
        return CGFloat(self.audioPlayer?.currentTime ?? 0)
    }
    
    /**Get the current time of an audio that is playing as TimeInterval.*/
    public func getCurrentTimeInterval() -> TimeInterval {
        if !(self.audioPlayer?.isPlaying ?? false) { return 0 }
        
        return self.audioPlayer?.currentTime ?? 0
    }
    
    /**Get the current time of an audio that is playing as TimeInterval.*/
    public func getCurrentTimeIntervalText() -> String {
        if !(self.audioPlayer?.isPlaying ?? false) { return "00:00" }
        
        let formatter = DateComponentsFormatter()
        return formatter.string(from: self.audioPlayer?.currentTime ?? 0)!
    }
    
    /**Set the current time of an audio that is playing.*/
    public func setCurrentTime(_ value: TimeInterval){
        self.audioPlayer?.currentTime = value
    }
    
    /**Get the total duration of the audio..*/
    public func getDuration() -> CGFloat {
        return CGFloat(self.audioPlayer?.duration ?? 0)
    }
    
    /**Get the is plating of the current AudioPlayer.*/
    public func getIsPlaying() -> Bool {
        return ((self.audioPlayer?.isPlaying) != nil)
    }
    
    //MARK: - PRIVATE METHODS
    private func prepareAudioPlayer() {
        self.audioPlayer?.delegate = self
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.setVolume(1, fadeDuration: 0)
        self.audioPlayer?.numberOfLoops = 0
    }
    
    //MARK: - STATIC FUNCS
    /**Returns the standard format of recorded audios (m4a).**/
    public static func getRecordedAudioFormat() -> String {
        return recordedAudioFormat
    }
}

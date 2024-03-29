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
        self.stopAudio()
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: audioURL, fileTypeHint: AVFileType.m4a.rawValue)
            self.prepareAudioPlayer()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - REPRODUTION
    /**Plays the audio that has been assigned previously.*/
    public func playAudio() {
        self.stopAudio()
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
    
    /**Tells if the given audio URL by parameter is the same that is currently assigned in AudioManager.*/
    public func isCurrentSameAudio(_ audioURL: URL) -> Bool {
        do {
            let givenAudio = try AVAudioPlayer(contentsOf: audioURL, fileTypeHint: AVFileType.m4a.rawValue)
            return self.audioPlayer == givenAudio
        } catch {
            return false
        }
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
    public func getDuration() -> Float {
        return Float(self.audioPlayer?.duration ?? 0)
    }
    
    /**Get the is playing of the current AudioPlayer.*/
    public func getIsPlaying() -> Bool {
        return ((self.audioPlayer?.isPlaying) != nil)
    }
    
    /**Get if the current AudioPlayer is stoped.*/
    public func getIsStoped() -> Bool {
        return !(self.audioPlayer?.isPlaying ?? false) && self.getCurrentTimeCGFloat() == 0
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

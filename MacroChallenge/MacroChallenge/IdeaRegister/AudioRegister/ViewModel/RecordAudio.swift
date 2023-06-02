//
//  RecordAudioVM.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Henrique Assis on 25/05/23.
//

import Foundation
import AVFoundation

class RecordAudio : NSObject, ObservableObject, AVAudioRecorderDelegate {
    // SWIFTUI Observers
    @Published var recordedAudios: [URL]
    
    // audio vars
    var audioSession: AVAudioSession
    var audioRecorder: AVAudioRecorder? // needs to be optinal, will only be created when there's a recorded audio
    var recordedAudioPath: String
    var recordSuccess: Bool
    
    // directory
    let fileManager: FileManager
    let documentDirectoryURL: URL
    let fileName: String
    
    //MARK: - INIT
    public override init() {
        // audio vars
        self.audioSession = AVAudioSession.sharedInstance()
        self.audioRecorder = nil
        self.recordedAudioPath = ""
        self.recordSuccess = false
        
        // directory
        self.fileManager = FileManager.default
        self.documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.fileName = "RecordedAudioBigIdea"
        
        // audio list
        self.recordedAudios = []
        
        // super init
        super.init()
        
        // initialization methods
        self.trySetSessionCategory()
        self.recordedAudios = self.fetchAudioURLs()
    }
    
    //MARK: - PUBLIC METHODS
    /**Starts to record an audio for audio ideias.**/
    public func startRecordingAudio() {
        self.recordSuccess = false
        // setting the final path of the audio, creating the UUID of the audio idea
        let fileUUID = UUID()
        let fileURL = self.documentDirectoryURL.appendingPathComponent("\(self.fileName)-\(fileUUID).\(AudioManager.getRecordedAudioFormat())")
        self.recordedAudioPath = fileURL.lastPathComponent
        
        // configuring the record settings
        let recordSettings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        // start the recording
        do {
            self.audioRecorder = try AVAudioRecorder(url: fileURL, settings: recordSettings)
            self.audioRecorder?.delegate = self
            self.audioRecorder?.record()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    /**Stops to record an audio if it is recording.**/
    public func stopRecordingAudio() {
        if !self.getIsRecording() { return }
        
        self.recordSuccess = true
        self.audioRecorder?.stop()
        self.audioRecorder = nil
        self.recordedAudios = self.fetchAudioURLs()
    }
    
    /**Returns if the audio recorder is recording.**/
    public func getIsRecording() -> Bool {
        return self.audioRecorder?.isRecording ?? false
    }
    
    /**Request the user the permission to access the dispositive recorder. Completion is called after user input, giving if he aloowed or not.**/
    public func requestPermission(completion: @escaping (Bool) -> Void){
        self.audioSession.requestRecordPermission { isAllowed in
            completion(isAllowed)
        }
    }
    
    /**Deletes all audio files in user directory.**/
    public func deleteAllAudios() {
        for audio in recordedAudios {
            do {
                try fileManager.removeItem(at: audio)
                self.recordedAudios = self.fetchAudioURLs()
            }
            
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /**Deletes the last audio file in user directory.**/
    public func deleteAudio(audioPath: String) {
        for audio in recordedAudios {
            if audio.lastPathComponent != audioPath { continue }
            
            do {
                try fileManager.removeItem(at: audio)
                self.recordedAudios = self.fetchAudioURLs()
            }
            
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    public func hasAudioInDirectory() -> Bool {
        return !fetchAudioURLs().isEmpty
    }
    
    //MARK: - PRIVATE METHODS
    /**Sets the category of the audio session to PlayAndRecord.**/
    private func trySetSessionCategory() {
        do {
            try self.audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try self.audioSession.setActive(true)
        }
        
        catch {
            print(error.localizedDescription)
        }
    }
    
    /**Fetch all recorded audios already created by the user.**/
    private func fetchAudioURLs() -> [URL] {
        // fetch data
        do {
            let result = try self.fileManager.contentsOfDirectory(at: self.documentDirectoryURL, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            return result
        }
        
        catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    //MARK: - AVAudioRecorderDelegate
    // needs this delegate function in case of record stops for something unusual, like an phone incoming call for example.
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //TODO: Handle a failure to record audio
        if self.recordedAudioPath != "" && !self.recordSuccess {
            print("teste")
            self.deleteAudio(audioPath: self.recordedAudioPath)
        }
    }
}

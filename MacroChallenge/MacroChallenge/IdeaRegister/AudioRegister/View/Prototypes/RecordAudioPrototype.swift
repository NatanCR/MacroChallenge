//
//  RecordAudioPrototype.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Henrique Assis on 25/05/23.
//

import SwiftUI
import AVFoundation

struct RecordAudioPrototype: View {
    @StateObject var recordAudio: RecordAudio
    
    @State var isRecording: Bool = false
    
    private var audioPlayer: AVAudioPlayer
    private let audioManager: AudioManager
    
    //MARK: - INIT
    public init() {
        self._recordAudio = StateObject(wrappedValue: RecordAudio())
        self.audioPlayer = AVAudioPlayer()
        self.audioManager = AudioManager(audioPlayer: self.audioPlayer)
    }
    
    //MARK: - BODY
    var body: some View {
        VStack {
            List(self.recordAudio.recordedAudios, id: \.self) { audioURL in
                Text(audioURL.relativeString)
                    .onTapGesture {
                        print("reproduzindo")
                        self.audioManager.playAudio(audioURL)
                    }
            }.background {
                Color(.systemGray4)
            }
            
            HStack {
                Spacer()
                
                Button {
                    self.isRecording = self.recordAudio.getIsRecording()
                    
                    if !isRecording {
                        print("recording")
                        self.recordAudio.startRecordingAudio()
                    } else {
                        print("stop record")
                        self.recordAudio.stopRecordingAudio()
                    }
                } label: {
                    Circle()
                        .frame(width: 100, height: 100)
                }
                
                Spacer()
                
                Button {
                    self.recordAudio.deleteAllAudios()
                } label: {
                    Rectangle()
                        .fill(Color(.red))
                        .frame(width: 100, height: 100)
                }
                
                Spacer()
            }

        }
    }
}

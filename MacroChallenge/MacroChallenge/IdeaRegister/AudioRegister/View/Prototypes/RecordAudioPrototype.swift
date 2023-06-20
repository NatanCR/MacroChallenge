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
        self.audioManager = AudioManager()
    }
    
    //MARK: - BODY
    var body: some View {
        VStack {
            List(self.recordAudio.recordedAudios, id: \.self) { audioURL in
                Text(audioURL.relativeString)
                    .onTapGesture {
                        self.audioManager.playAudio()
                    }
            }.background {
                Color(.systemGray4)
            }
            
            HStack {
                Spacer()
                
                Button {
                    self.isRecording = self.recordAudio.getIsRecording()
                    
                    if !isRecording {
                        self.recordAudio.startRecordingAudio()
                    } else {
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

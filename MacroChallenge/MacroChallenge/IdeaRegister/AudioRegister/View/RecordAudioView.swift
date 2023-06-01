//
//  RecordAudioView.swift
//  MacroChallenge
//
//  Created by Henrique Assis on 31/05/23.
//

import SwiftUI
import AVFoundation

struct RecordAudioView: View {
    // states
    @StateObject var recordAudio: RecordAudio
    @State var isRecording: Bool = true
    @State var recorded: Bool = false
    @State var audioUrl: URL?
    
    // audio
    private var audioPlayer: AVAudioPlayer?
    private let audioManager: AudioManager
    
    //MARK: - INIT
    init() {
        self._recordAudio = StateObject(wrappedValue: RecordAudio())
        self.audioPlayer = AVAudioPlayer()
        self.audioManager = AudioManager(audioPlayer: AVAudioPlayer())
    }
    
    //MARK: - BODY
    var body: some View {
        VStack {
            Spacer()
            
            // recording indicator
            if self.isRecording {
                Text("Gravando")
                    .foregroundColor(.red)
            } else if (self.recorded) {
                HStack {
                    AudioReprodutionComponent(audioManager: self.audioManager, audioURL: self.recordAudio.recordedAudios.last!)
                        .frame(height: 10)
                        .padding(.trailing, 30)
                    
                    Button {
                        self.recorded = false
                        self.recordAudio.deleteAllAudios()
                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 23, height: 23)
                    }
                }
            }
            
            Spacer(minLength: 600)
            
            // record and stop button
            Button {
                self.isRecording.toggle()

                // if started recording
                if isRecording {
                    self.recordAudio.startRecordingAudio()
                } else { // if stop the record
                    self.recordAudio.stopRecordingAudio()
                    self.audioManager.assignAudio(self.recordAudio.recordedAudios.last!)
                    self.recorded = true
                }
            } label: {
                Image(systemName: self.isRecording ? "stop.fill" : "mic.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 23, height: 23)
            }.disabled(self.recorded)
            
            Spacer()
        }
        .navigationTitle("Inserir áudio")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Salvar") {
                    //TODO: Save
                    print("save")
                }
            }
        }.onAppear {
            self.recordAudio.startRecordingAudio()
        }
    }
}

struct RecordAudioView_Previews: PreviewProvider {
    static var previews: some View {
        RecordAudioView()
    }
}

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
    @State var isRecording: Bool
    @State var recorded: Bool
    
    // audio
    private var audioPlayer: AVAudioPlayer?
    private let audioManager: AudioManager
    
    //MARK: - INIT
    init() {
        self.isRecording = true
        self.recorded = false
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
            }
            
            Spacer(minLength: 600)
            
            // record and stop button
            Button {
                self.isRecording.toggle()

                // if started recording
                if isRecording {
                    print("gravando")
                } else { // if stop the record
                    print("parou")
                }
            } label: {
                Image(systemName: self.isRecording ? "stop.fill" : "mic.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 23, height: 23)
            }
            
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
        }
    }
}

struct RecordAudioView_Previews: PreviewProvider {
    static var previews: some View {
        RecordAudioView()
    }
}

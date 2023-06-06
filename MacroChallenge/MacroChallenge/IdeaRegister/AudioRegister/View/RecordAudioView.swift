//
//  RecordAudioView.swift
//  MacroChallenge
//
//  Created by Henrique Assis on 31/05/23.
//

import SwiftUI
import AVFoundation

struct RecordAudioView: View {
    @Environment(\.dismiss) private var dismiss
    
    // states
    @StateObject var recordAudio: RecordAudio
    @State var isRecording: Bool = true
    @State var recorded: Bool = false
    @State var audioUrl: URL?
    
    // audio
    private let audioManager: AudioManager
    
    //MARK: - INIT
    init() {
        self._recordAudio = StateObject(wrappedValue: RecordAudio())
        self.audioManager = AudioManager()
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
                    AudioReprodutionComponent(audioManager: self.audioManager, audioURL: AudioHelper.getAudioContent(audioPath: self.audioUrl!.lastPathComponent))
                        .frame(height: 10)
                        .padding(.trailing, 30)
                    
                    Button {
                        self.recorded = false
                        self.audioManager.stopAudio()
                        self.recordAudio.deleteAudio(audioPath: self.recordAudio.recordedAudioPath)
                        
//                        self.recordAudio.deleteAllAudios()
//                        IdeaSaver.clearAll()
                    } label: {
                        Image(systemName: "trash.fill")
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
                    self.audioUrl = AudioHelper.getAudioContent(audioPath: self.recordAudio.recordedAudioPath)
                    self.audioManager.assignAudio(self.audioUrl!)
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
                    if isRecording {
                        self.recordAudio.stopRecordingAudio()
                        self.recordAudio.deleteAudio(audioPath: self.recordAudio.recordedAudioPath)
                        self.recorded = false
                    }
                    
                    if recorded {
                        let idea = AudioIdeia(title: "test", description: "", textComplete: "", creationDate: Date(), modifiedDate: Date(), audioPath: self.audioUrl?.lastPathComponent ?? "")
                        IdeaSaver.saveAudioIdea(idea: idea)
                    }
                    
                    dismiss()
                }
            }
        }.onAppear {
            self.audioUrl = nil
            self.recordAudio.startRecordingAudio()
            //print(try? self.recordAudio.fileManager.contentsOfDirectory(at: self.recordAudio.documentDirectoryURL, includingPropertiesForKeys: nil, options: .producesRelativePathURLs))
        }
    }
}

struct RecordAudioView_Previews: PreviewProvider {
    static var previews: some View {
        RecordAudioView()
    }
}

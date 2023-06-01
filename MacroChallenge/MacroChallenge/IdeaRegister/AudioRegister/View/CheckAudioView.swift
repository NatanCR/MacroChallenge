//
//  CheckAudioView.swift
//  MacroChallenge
//
//  Created by Henrique Assis on 01/06/23.
//

import SwiftUI
import AVFoundation

struct CheckAudioView: View {
    @Environment(\.dismiss) private var dismiss
    
    //idea
    private let idea: AudioIdeia
    
    // audio
    private var audioPlayer: AVAudioPlayer?
    private let audioManager: AudioManager
    
    // date
    let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    
    init(audioIdea idea: AudioIdeia) {
        self.audioPlayer = AVAudioPlayer()
        self.audioManager = AudioManager(audioPlayer: AVAudioPlayer())
        self.idea = idea
    }
    
    //MARK: - BODY
    var body: some View {
        VStack {
            Text("Ideia do dia \(idea.creationDate.toString(dateFormatter: self.dateFormatter)!)")
                .font(.system(size: 23))
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            
            AudioReprodutionComponent(audioManager: self.audioManager, audioURL: self.idea.audioPath)
                .frame(height: 10)
                .padding(.top, 30)
            
            Spacer()
        }
        .onAppear(perform: {
            self.audioManager.assignAudio(self.idea.audioPath)
            print(idea.audioPath)
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    IdeaSaver.clearOneIdea(type: AudioIdeia.self, idea: self.idea)
                    dismiss()
                } label: {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.red)
                }

            }
        }
    }
}

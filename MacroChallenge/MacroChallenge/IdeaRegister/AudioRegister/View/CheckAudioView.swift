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
    private let audioManager: AudioManager
    @State private var audioUrl: URL?
    
    // date
    let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    
    init(audioIdea idea: AudioIdeia) {
        self.audioManager = AudioManager()
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
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let contents = try? FileManager.default.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            let index = contents?.firstIndex(where: { $0.lastPathComponent == idea.audioPath.lastPathComponent}) ?? -1
            print(index)
            audioUrl = contents![index]
            self.audioManager.assignAudio(contents![index])
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

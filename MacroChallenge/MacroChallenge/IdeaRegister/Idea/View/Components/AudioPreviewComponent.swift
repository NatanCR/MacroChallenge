//
//  AudioPreviewComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct AudioPreviewComponent: View {
    var title: String
    var description: String
    let audioManager: AudioManager
    
    let idea: AudioIdeia
    
    init(title: String, description: String, audioManager: AudioManager, idea: AudioIdeia) {
        self.title = title
        self.description = description
        self.audioManager = audioManager
        self.idea = idea
    }
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("backgroundItem"))
                    .frame(width: 100, height: 100)
                VStack{
                    Image(systemName: "waveform.and.mic")
                        .font(.system(size: 30, design: .rounded))
                        .foregroundColor(Color("labelColor"))
                    
                    PlayPreviewComponent(audioManager: self.audioManager, idea: idea)
                }
            }
            Text(title)
                .font(.custom("Sen-Regular", size: 20, relativeTo: .headline))
            Text(description)
                .font(.custom("Sen-Regular", size: 15, relativeTo: .headline))
        }
    }
}

struct PlayPreviewComponent: View {
    @Environment(\.screenSize) var screenSize
    @State var sliderValue : Float = 0.0
    @State var audioTimeText: String = "00:00"
    @State var isPlaying: Bool = false
    
    let audioManager: AudioManager
    let idea: AudioIdeia
    
    private let sliderTime = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    private let finishedAudioNotification = NotificationCenter.default.publisher(for: NSNotification.Name("FinishedAudio"))
    
    var body: some View{
        HStack{
            Button {
                isPlaying.toggle()
                
                if isPlaying {
                    let audioURL = ContentDirectoryHelper.getDirectoryContent(contentPath: idea.audioPath)
                    self.audioManager.assignAudio(audioURL)
                    audioManager.playAudio()
                } else {
                    self.sliderValue = Float(self.audioManager.getCurrentTimeCGFloat())
                    audioManager.pauseAudio()
                }
            } label: {
                Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
                    .foregroundColor(Color("labelColor"))
            }
            // notification recebida com o timer
            .onReceive(sliderTime) { _ in
                if !isPlaying {return}
                
                // se o audio foi reproduzido por completo, seta o valor do slider pra duracao maxima do audio
                if self.audioManager.getIsStoped() && self.isPlaying {
                    self.sliderValue = self.audioManager.getDuration()
                    return
                }
                self.sliderValue = Float(self.audioManager.getCurrentTimeCGFloat())
                self.audioTimeText = self.convertCurrentTime()
            }
            // notification ativada quando verifica que o audio terminou de ser reproduzido por completo
            .onReceive(finishedAudioNotification) { _ in
                self.isPlaying = false
                self.sliderValue = 0
                self.audioTimeText = self.convertCurrentTime()
                print("noti")
            }
            
            AudioSliderView(value: $sliderValue, audioTimeText: $audioTimeText, audioManager: audioManager)
                .frame(width: screenSize.width * 0.12)
        }
        .padding(2)
    }
    
    private func convertCurrentTime() -> String {
        let time = Int(self.audioManager.getCurrentTimeInterval())
        let seconds = time % 60
        let minutes = (time / 60) % 60
        
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}

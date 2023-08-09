//
//  AudioPreviewComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

//MARK: - AUDIO PREVIEW
struct AudioPreviewComponent: View {
    @Environment(\.screenSize) var screenSize
    var title: String
    @State var idea: any Idea
    @ObservedObject var ideasViewModel: IdeasViewModel
    @State private var isAlertActive: Bool = false
    let audioManager: AudioManager
    
    @Binding var isAdding: Bool
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("backgroundItem"))
                    .frame(width: screenSize.width * 0.26, height: screenSize.width * 0.26)
                    .overlay(alignment: .topTrailing){
                        
                        OverlayComponent(type: AudioIdeia.self, text: "", idea: idea as! AudioIdeia, isAdding: $isAdding)
                        .padding(8)
                    }
                
                VStack{
                    
                    PlayPreviewComponent(audioManager: self.audioManager, idea: idea as! AudioIdeia)
                }
            }
            .padding(.bottom, 5)
            
            //deletar
            .contextMenu{
                Button(role: .destructive){
                    isAlertActive = true
                } label: {
                    HStack{
                        Text("del")
                        Image(systemName: "trash")
                    }
                }
            }

            Text(title)
                .font(.custom("Sen-Bold", size: 17, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
            Text(self.ideasViewModel.isSortedByCreation ? idea.creationDate.toString(dateFormatter: IdeasViewModel.dateFormatter)! : idea.modifiedDate.toString(dateFormatter: IdeasViewModel.dateFormatter)!)
                .font(.custom("Sen-Regular", size: 15, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
            Text(self.ideasViewModel.isSortedByCreation ? idea.creationDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())! : idea.modifiedDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())!)
                .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
        }
        .confirmationDialog("delMsg", isPresented: $isAlertActive) {
            Button("delIdea", role: .destructive) {
                //deletar
                IdeaSaver.clearOneIdea(type: AudioIdeia.self, idea: idea as! AudioIdeia)
                self.ideasViewModel.resetDisposedData()
                
                if let audioIdea = idea as? AudioIdeia {
                    ContentDirectoryHelper.deleteAudioFromDirectory(audioPath: audioIdea.audioPath)
                }


            }
        }
    }
}

//MARK: - PLAY PREVIEW
struct PlayPreviewComponent: View {
    // environments
    @Environment(\.screenSize) var screenSize
    
    // states
    @State var sliderValue : Float = 0.0
    @State var audioTimeText: String = "00:00"
    @State var isPlaying: Bool = false
    @State var isPlayedBySelf: Bool = false
    @State var isCurrentlyPlaying: Bool = false
    
    // instances
    let audioManager: AudioManager
    let idea: AudioIdeia
    
    // receivers
    private let sliderTime = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    private let finishedAudioNotification = NotificationCenter.default.publisher(for: NSNotification.Name("FinishedAudio"))
    private let playedAnotherAudioNotification = NotificationCenter.default.publisher(for: NSNotification.Name("PlayedAnotherAudio"))
    
    //MARK: - INIT
    init(audioManager: AudioManager, idea: AudioIdeia) {
        self.audioManager = audioManager
        self.idea = idea
        
        let audioURL = ContentDirectoryHelper.getDirectoryContent(contentPath: idea.audioPath)
        self.audioManager.assignAudio(audioURL)
    }
    
    //MARK: - BODY
    var body: some View{
        VStack{
            
            Button {
                if !self.isPlaying {
                    self.isPlayedBySelf = true
                    NotificationCenter.default.post(name: Notification.Name("PlayedAnotherAudio"), object: self)
                }
                
                self.isPlaying.toggle()
                
                if isPlaying {
                    self.playButton()
                } else {
                    self.pauseButton()
                }
            } label: {
                Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
                    .foregroundColor(Color("labelColor"))
                    .font(.system(size: screenSize.width * 0.07))
            }
            // notification recebida com o timer
            .onReceive(sliderTime) { _ in
                self.updateSliderTimer()
            }
            // notification ativada quando verifica que o audio terminou de ser reproduzido por completo
            .onReceive(finishedAudioNotification) { _ in
                self.resetAudioTimer()
            }
            // notification ativada quando algum preview da grid da play
            .onReceive(playedAnotherAudioNotification) { _ in
                self.playedAnotherAudio()
            }
            .padding()
            
            ProgressView(value: sliderValue, total: audioManager.getDuration())
                .frame(width: screenSize.width * 0.2)
                .background(Color("audio"))
        }
    }
    
    //MARK: - METHODS
    private func playButton() {
        if !self.isCurrentlyPlaying {
            self.isCurrentlyPlaying = true
            let audioURL = ContentDirectoryHelper.getDirectoryContent(contentPath: idea.audioPath)
            self.audioManager.assignAudio(audioURL)
        }
        
        audioManager.playAudio()
    }
    
    private func pauseButton() {
        self.sliderValue = Float(self.audioManager.getCurrentTimeCGFloat())
        audioManager.pauseAudio()
    }
    
    private func updateSliderTimer() {
        if !isPlaying {return}
        
        // se o audio foi reproduzido por completo, seta o valor do slider pra duracao maxima do audio
        if self.audioManager.getIsStoped() && self.isPlaying {
            self.sliderValue = self.audioManager.getDuration()
            NotificationCenter.default.post(name: Notification.Name("FinishedAudio"), object: self)
            return
        }
        self.sliderValue = Float(self.audioManager.getCurrentTimeCGFloat())
        self.audioTimeText = self.convertCurrentTime()
    }
    
    private func playedAnotherAudio() {
        if self.isPlayedBySelf {
            self.isPlayedBySelf = false
            return
        }
        
        if self.isPlaying {
            self.resetAudioTimer()
        }
    }
    
    private func convertCurrentTime() -> String {
        let time = Int(self.audioManager.getCurrentTimeInterval())
        let seconds = time % 60
        let minutes = (time / 60) % 60
        
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
    private func resetAudioTimer() {
        self.isPlaying = false
        self.isCurrentlyPlaying = false
        self.isPlayedBySelf = false
        self.sliderValue = 0
        self.audioTimeText = self.convertCurrentTime()
    }
}

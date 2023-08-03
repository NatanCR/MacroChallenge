//
//  AudioReprodutionComponent.swift
//  MacroChallenge
//
//  Created by Henrique Assis on 31/05/23.
//

import UIKit
import SwiftUI
import AVFoundation

struct AudioReprodutionComponent: View {
    @State var isPlaying: Bool = false
    @State var audioCurrentTime: Float = 0
    @State var finishedAudio: Bool = false
    @State var audioTimeText: String = "00:00"
    @State var isCurrentSlider: Bool = true
    
    private let sliderTime = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    private let finishedAudioNotification = NotificationCenter.default.publisher(for: NSNotification.Name("FinishedAudio"))
    private let audioManager: AudioManager
    private let audioURL: URL
    
    //MARK: - INIT
    init(audioManager: AudioManager, audioURL: URL) {
        self.audioManager = audioManager
        self.audioURL = audioURL
    }
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 270, height: 40)
                .foregroundColor(Color("backgroundItem"))
                .opacity(0.6)
            
            HStack {
                Button {
                    self.isPlaying.toggle()
                    if isPlaying {
                        audioManager.playAudio()
                    } else {
                        self.audioCurrentTime = Float(self.audioManager.getCurrentTimeCGFloat())
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
                        self.audioCurrentTime = self.audioManager.getDuration()
                        return
                    }
                    
                    self.audioCurrentTime = Float(self.audioManager.getCurrentTimeCGFloat())
                    self.audioTimeText = self.convertCurrentTime()
                }
                // notification ativada quando verifica que o audio terminou de ser reproduzido por completo
                .onReceive(finishedAudioNotification) { _ in
                    self.isPlaying = false
                    self.audioCurrentTime = 0
                    self.audioTimeText = self.convertCurrentTime()
                }
                
                AudioSliderView(value: $audioCurrentTime, audioTimeText: $audioTimeText, audioManager: self.audioManager)
                    .frame(width: 124)
                    .padding()
                
                Text(self.audioTimeText)
                    .font(.custom("Sen-Regular", size: 13))
                    .foregroundColor(Color("labelColor"))
                    .monospacedDigit()
            }
        }
    }
    
    //MARK: - FUNCs
    private func convertCurrentTime() -> String {
        let time = Int(self.audioManager.getCurrentTimeInterval())
        let seconds = time % 60
        let minutes = (time / 60) % 60
        
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}

//MARK: - SLIDER
struct AudioSliderView : UIViewRepresentable {
    @Binding var value: Float
    @Binding var audioTimeText: String
    
    let slider: UISlider = UISlider(frame: .zero)
    private let audioManager: AudioManager
    let isFromAudioCheck: Bool
    
    public init(value: Binding<Float>, audioTimeText: Binding<String>, audioManager: AudioManager, isFromAudioCheck: Bool = true) {
        self._value = value
        self._audioTimeText = audioTimeText
        self.audioManager = audioManager
        self.isFromAudioCheck = isFromAudioCheck
    }
    
    //MARK: - COORDINATOR
    class Coordinator: NSObject {
        var sliderView: AudioSliderView
        var sliderTimer: Timer?
        
        init(_ sliderView: AudioSliderView) {
            self.sliderView = sliderView
        }
        
        //MARK: OBJC FUNCs
        // func that is called when user changes the slider value manually
        @objc func sliderChange(_ sender: UISlider!) {
            self.sliderView.audioManager.setCurrentTime(TimeInterval(sender.value))
            self.sliderView.value = sender.value
            self.sliderView.audioTimeText = self.convertCurrentTime()
        }
        
        // called when the user drags the finger along the slider bar
        @objc func sliderDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
            let point = gestureRecognizer.location(in: self.sliderView.slider)
            let width = self.sliderView.slider.bounds.width
            let value = point.x / width * CGFloat(self.sliderView.slider.maximumValue)
            
            switch gestureRecognizer.state {
            case .began, .changed:
                self.sliderView.slider.value = Float(value)
                self.sliderChange(self.sliderView.slider)
            default:
                break
            }
        }
        
        // called when the user tap the slider bar
        @objc func sliderTapped(_ gestureRecognizer: UITapGestureRecognizer) {
            let point = gestureRecognizer.location(in: self.sliderView.slider)
            let width = self.sliderView.slider.bounds.width
            let value = point.x / width * CGFloat(self.sliderView.slider.maximumValue)
            self.sliderView.slider.value = Float(value)
            self.sliderChange(self.sliderView.slider)
        }
        
        //MARK: PRIVATE FUNCs
        private func convertCurrentTime() -> String {
            let time = Int(self.sliderView.value)
            let seconds = time % 60
            let minutes = (time / 60) % 60
            
            return String(format: "%0.2d:%0.2d", minutes, seconds)
        }
    }
    
    //MARK: - SLIDER FUNCs
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UISlider {
        slider.minimumValue = 0
        slider.maximumValue = Float(self.audioManager.getDuration())
        slider.minimumTrackTintColor = UIColor(Color("labelColor"))
        slider.maximumTrackTintColor = UIColor(Color("backgroundColor"))
        slider.addTarget(context.coordinator, action: #selector(Coordinator.sliderChange(_:)), for: .valueChanged)
        slider.setThumbImage(thumbImage(size: CGSize(width: 9, height: 9)), for: .normal)
        slider.value = value
        
        // add tap and drag gestures to the slider
        let panGestureRecognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.sliderDragged(_:)))
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.sliderTapped(_:)))
        
        if isFromAudioCheck {
            slider.addGestureRecognizer(panGestureRecognizer)
            slider.addGestureRecognizer(tapGestureRecognizer)
        }
        
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        DispatchQueue.main.async {
            uiView.value = value
        }
        
        // se o slider for maior ou igual ao tempo total do audio, ativa a notificacao de termino de audio
        if value >= audioManager.getDuration() {
            NotificationCenter.default.post(name: Notification.Name("FinishedAudio"), object: self)
        }
    }
    
    func thumbImage(size: CGSize) -> UIImage {
        var thumb = UIImage()
        var resized = UIImage()
        
        if isFromAudioCheck {
            thumb = UIImage(systemName: "circle.fill")?.withTintColor(UIColor(Color("labelColor")), renderingMode: .alwaysOriginal) ?? UIImage()
            
            resized = UIGraphicsImageRenderer(size: size).image { _ in
                thumb.draw(in: CGRect(origin: .zero, size: size))
            }
        }
        
        return resized.withRenderingMode(.alwaysOriginal)
    }
}

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
                        audioManager.playAudio(self.audioURL)
                    } else {
                        audioManager.pauseAudio()
                    }
                    
                } label: {
                    Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(Color("labelColor"))
                }
                .onReceive(sliderTime) { _ in
                    if !isPlaying {return}

                    self.audioCurrentTime = Float(self.audioManager.getCurrentTimeCGFloat())
                    if self.audioCurrentTime >= self.audioManager.getDuration() && self.isPlaying {
                        self.isPlaying = false
                        self.audioCurrentTime = 0
                        print("finish")
                    }
                }
                
                .onReceive(finishedAudioNotification) { _ in
                    self.isPlaying = false
                    self.audioCurrentTime = 0
                }
                
                AudioSliderView(value: $audioCurrentTime, audioManager: self.audioManager)
                    .frame(width: 124)
                    .padding()
                
                Text(self.convertCurrentTime())
                    .font(.system(size: 13))
                    .foregroundColor(Color("labelColor"))
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
    
    let slider: UISlider = UISlider(frame: .zero)
    private let audioManager: AudioManager
    
    public init(value: Binding<Float>, audioManager: AudioManager) {
        self._value = value
        self.audioManager = audioManager
    }
    
    //MARK: - COORDINATOR
    class Coordinator: NSObject {
        var sliderView: AudioSliderView
        var sliderTimer: Timer?
        
        init(_ sliderView: AudioSliderView) {
            self.sliderView = sliderView
        }
        
        // func that is called when user changes the slider value manually
        @objc func sliderChange(_ sender: UISlider!) {
            self.sliderView.audioManager.setCurrentTime(TimeInterval(sender.value))
            self.sliderView.value = sender.value
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
        
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = value
        if value >= self.audioManager.getDuration() - 0.04 {
            NotificationCenter.default.post(name: Notification.Name("FinishedAudio"), object: self)
        }
    }
    
    func thumbImage(size: CGSize) -> UIImage {
        let thumb = UIImage(systemName: "circle.fill")?.withTintColor(UIColor(Color("labelColor")), renderingMode: .alwaysOriginal)
        
        let resized = UIGraphicsImageRenderer(size: size).image { _ in
            thumb?.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return resized.withRenderingMode(.alwaysOriginal)
    }
}

struct AudioReprodutionComponent_Previews: PreviewProvider {
    static var previews: some View {
        AudioReprodutionComponent(audioManager: AudioManager(), audioURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    }
}

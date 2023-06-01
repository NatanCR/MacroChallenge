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
    
    private let sliderTime = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
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
                .foregroundColor(Color(hex: "1857C1"))
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
                        .foregroundColor(.white)
                }.onReceive(sliderTime) { _ in
                    if !isPlaying {return}
                    
                    self.audioCurrentTime = Float(self.audioManager.getCurrentTimeCGFloat())
                }
                
                AudioSliderView(value: $audioCurrentTime, isPlaying: $isPlaying, audioManager: self.audioManager)
                    .frame(width: 124)
                    .padding()
                
                Text(self.convertCurrentTime())
                    .font(.system(size: 13))
                    .foregroundColor(.white)
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
    @Binding var value : Float
    @Binding var isPlaying: Bool
    
    let slider: UISlider = UISlider(frame: .zero)
    private let audioManager: AudioManager
    
    public init(value: Binding<Float>, isPlaying: Binding<Bool>, audioManager: AudioManager) {
        self._value = value
        self._isPlaying = isPlaying
        self.audioManager = audioManager
    }
    
    //MARK: - COORDINATOR
    class Coordinator: NSObject {
        var sliderView: AudioSliderView
        var sliderTimer: Timer?
        
        init(_ sliderView: AudioSliderView) {
            self.sliderView = sliderView
        }
        
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
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.32)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.sliderChange(_:)), for: .valueChanged)
        slider.setThumbImage(thumbImage(size: CGSize(width: 9, height: 9)), for: .normal)
        
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) { }
    
    func thumbImage(size: CGSize) -> UIImage {
        let thumb = UIImage(systemName: "circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        let resized = UIGraphicsImageRenderer(size: size).image { _ in
            thumb?.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return resized.withRenderingMode(.alwaysOriginal)
    }
}

struct AudioReprodutionComponent_Previews: PreviewProvider {
    static var previews: some View {
        AudioReprodutionComponent(audioManager: AudioManager(audioPlayer: AVAudioPlayer()), audioURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    }
}

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
    @State var timeStamp: String = "00:00"
    
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
                }
                
                AudioSliderView(value: $audioCurrentTime, audioManager: self.audioManager)
                    .frame(width: 124)
                    .padding()
                
                Text(audioManager.getCurrentTimeIntervalText())
                    .font(.system(size: 13))
                    .foregroundColor(.white)
            }
        }
    }
}

struct AudioSliderView : UIViewRepresentable {
    @Binding var value : Float
    private let audioManager: AudioManager
    
    public init(value: Binding<Float>, audioManager: AudioManager) {
        self._value = value
        self.audioManager = audioManager
    }
    
    class Coordinator: NSObject {
        var sliderView: AudioSliderView
        
        init(_ sliderView: AudioSliderView) {
            self.sliderView = sliderView
        }
        
        @objc func sliderChange(_ sender: UISlider!) {
            self.sliderView.audioManager.setCurrentTime(TimeInterval(sender.value))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
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

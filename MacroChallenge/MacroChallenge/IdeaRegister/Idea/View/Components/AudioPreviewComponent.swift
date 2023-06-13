//
//  AudioPreviewComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct AudioPreviewComponent: View {
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("backgroundItem"))
                    .frame(width: 100, height: 100)
                    .overlay(alignment: .topTrailing){
                        Button{
                            
                        } label: {
                            Image(systemName: "heart")
                        }
                        .padding(8)
                    }
                VStack{
                    Image(systemName: "waveform.and.mic")
                        .font(.system(size: 30, design: .rounded))
                        .foregroundColor(Color("labelColor"))
                    
                    PlayPreviewComponent()
                }
            }
            Text("Title")
                .font(.custom("Sen-Regular", size: 20))
            Text("Description")
                .font(.custom("Sen-Regular", size: 15))
        }
    }
}

struct PlayPreviewComponent: View {
    
    @State var sliderValue : Float = 0.0
    var body: some View{
        HStack{
            Button {
                //TODO: ação de play do preview
                print("fazer ação de play")
            } label: {
                Image(systemName: "play.fill")
                    .foregroundColor(Color("labelColor"))
            }
            
            Slider(value: $sliderValue, in: 0...10)
                .frame(width: 50)
        }
        .padding(2)

    }
}

struct AudioPreviewComponent_Previews: PreviewProvider {
    static var previews: some View {
        AudioPreviewComponent()
    }
}

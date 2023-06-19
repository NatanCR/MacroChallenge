//
//  AudioPreviewComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct AudioPreviewComponent: View {
    @Environment(\.screenSize) var screenSize

    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("backgroundItem"))
                    .frame(width: screenSize.width * 0.29, height: screenSize.width * 0.29)
                    .overlay(alignment: .topTrailing){
                        Button{
                            
                        } label: {
                            Image(systemName: "heart")
                                .font(.system(size: 20))

                        }
                        .padding(8)
                    }
                VStack{
                    Image(systemName: "waveform.and.mic")
                        .font(.system(size: screenSize.width * 0.08, design: .rounded))
                        .foregroundColor(Color("labelColor"))
                        .padding(.bottom)
                    PlayPreviewComponent()
                }
            }
            .padding(.bottom, 5)

            Text("Titulo grande para testar essa merda")
                .font(.custom("Sen-Regular", size: 20))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.02)
            Text("14/02/2004")
                .font(.custom("Sen-Regular", size: 17))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.02)
        }
    }
}

struct PlayPreviewComponent: View {
    @Environment(\.screenSize) var screenSize
    @State var sliderValue : Float = 0.0
    var body: some View{
        HStack{
            
            Button {
                //TODO: ação de play do preview
                print("fazer ação de play")
            } label: {
                Image(systemName: "play.fill")
                    .foregroundColor(Color("labelColor"))
                    .font(.system(size: screenSize.width * 0.04))
            }
            
            Slider(value: $sliderValue, in: 0...10)
                .frame(width: screenSize.width * 0.18)
        }

    }
}

struct AudioPreviewComponent_Previews: PreviewProvider {
    static var previews: some View {
        AudioPreviewComponent()
    }
}

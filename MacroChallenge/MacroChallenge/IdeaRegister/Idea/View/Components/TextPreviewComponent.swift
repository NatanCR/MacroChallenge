//
//  TextPreviewView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct TextPreviewComponent: View {
    @Environment(\.screenSize) var screenSize
    var text: String
    var title: String
    var description: String
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("backgroundItem"))
                    .frame(width: screenSize.width * 0.29, height: screenSize.width * 0.29)
                    .overlay(alignment: .topTrailing){
                        Button{
                            
                        } label: {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color("deleteColor"))
                        }
                        .padding(8)
                    }
                Text(text)
                    .foregroundColor(Color("labelColor"))
                    .font(Font.custom("Sen-Regular", size: 17))
                    .frame(width: screenSize.width * 0.25, height: screenSize.width * 0.15)
                
            }
            .padding(.bottom, 5)

            Text("Titulo grande para testar")
                .font(.custom("Sen-Regular", size: 20))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.02)
            Text("Description")
                .font(.custom("Sen-Regular", size: 17))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.02)
                    .font(Font.custom("Sen-Regular", size: 17, relativeTo: .headline))
                    .frame(width: 80, height: 80)
                
            }
            Text(title)
                .font(.custom("Sen-Regular", size: 20, relativeTo: .headline))
            Text(description)
                .font(.custom("Sen-Regular", size: 15, relativeTo: .headline))
        }
    }
}

struct TextPreviewComponent_Previews: PreviewProvider {
    static var previews: some View {
        TextPreviewComponent(text: "", title: "", description: "")
    }
}

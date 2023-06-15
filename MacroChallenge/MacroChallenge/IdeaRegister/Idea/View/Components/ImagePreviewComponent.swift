//
//  ImagePreviewComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct ImagePreviewComponent: View {
    @Environment(\.screenSize) var screenSize
    var image: UIImage
    var title: String
    var description: String
    
    var body: some View {
        VStack{
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: screenSize.width * 0.29, height: screenSize.width * 0.29)
                .cornerRadius(20)
                .overlay(alignment: .topTrailing){
                    Button{
                        
                    } label: {
                        Image(systemName: "heart")
                            .font(.system(size: 20))
                            .foregroundColor(Color("deleteColor"))

                    }
                    .padding(8)
                }
                .padding(.bottom, 5)
            Text("Título Grande para Testes")
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.02)
                .rotationEffect(.degrees(90))
            
            Text(title)
                .font(.custom("Sen-Regular", size: 20))
            
            Text("12/03/2023")
                .font(.custom("Sen-Regular", size: 17))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.02)
                .font(.custom("Sen-Regular", size: 20, relativeTo: .headline))
                .frame(width: 95, height: 20)
            
            Text(description)
                .font(.custom("Sen-Regular", size: 15, relativeTo: .headline))
                .frame(width: 95, height: 20)
        }
    }
}

struct ImagePreviewComponent_Previews: PreviewProvider {
    static var previews: some View {
        ImagePreviewComponent(image: UIImage(), title: "", description: "")
    }
}

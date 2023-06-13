//
//  ImagePreviewComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct ImagePreviewComponent: View {
    var image: UIImage
    
    var body: some View {
        VStack{
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(20)
                .overlay(alignment: .topTrailing){
                    Button{
                        
                    } label: {
                        Image(systemName: "heart")
                    }
                    .padding(8)
                }
            
            Text("Title")
                .font(.custom("Sen-Regular", size: 20))
                .frame(width: 95, height: 20)
            
            Text("Description")
                .font(.custom("Sen-Regular", size: 15))
                .frame(width: 95, height: 20)
        }
    }
}

struct ImagePreviewComponent_Previews: PreviewProvider {
    static var previews: some View {
        ImagePreviewComponent(image: UIImage())
    }
}

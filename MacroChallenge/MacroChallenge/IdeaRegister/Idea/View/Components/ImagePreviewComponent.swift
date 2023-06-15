//
//  ImagePreviewComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct ImagePreviewComponent: View {
    var image: UIImage
    var title: String
    var description: String
    
    var body: some View {
        VStack{
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(20)
                .rotationEffect(.degrees(90))
            
            Text(title)
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

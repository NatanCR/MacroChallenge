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
            Text("Title")
                .font(.custom("Sen-Regular", size: 20))
            Text("Description")
                .font(.custom("Sen-Regular", size: 15))
        }
    }
}

struct ImagePreviewComponent_Previews: PreviewProvider {
    static var previews: some View {
        ImagePreviewComponent(image: UIImage())
    }
}

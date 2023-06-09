//
//  ListRowComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 07/06/23.
//

import SwiftUI

struct ListRowComponent: View {
    
    var title: String
    var info: String
    var image: UIImage
    
    var body: some View {
        HStack{
            
            VStack(alignment: .leading){
                Text(title)
                    .font(Font.custom("Sen-Regular", size: 20))
                    .foregroundColor(Color("labelColor"))
                Text(info)
                    .font(Font.custom("Sen-Regular", size: 15))
                    .foregroundColor(Color("labelColor"))
                    .opacity(0.5)
            }
            
            Spacer()
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 30, height: 30)
                .cornerRadius(5)

        }.padding()
        
    }
}

struct ListRowComponent_Previews: PreviewProvider {
    static var previews: some View {
        
        ListRowComponent(title: "teste", info: "data de adição ou edição", image: UIImage(systemName: "rectangle.fill") ?? UIImage())
    }
}

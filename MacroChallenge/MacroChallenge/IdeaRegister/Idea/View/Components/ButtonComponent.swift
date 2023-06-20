//
//  ButtonComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 09/06/23.
//

import SwiftUI

struct ButtonComponent: View {
    @Environment(\.screenSize) var screenSize
    var title: String
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30)
                .frame(width: screenSize.width * 0.9, height: screenSize.height * 0.1)
                .foregroundColor(Color("AccentColor"))
            
            HStack{
                Text(title)
                    .font(Font.custom("Sen-Regular", size: 20, relativeTo: .headline))
                    .frame(maxWidth: screenSize.width * 0.7, maxHeight: screenSize.height * 0.01, alignment: .leading)
                    .foregroundColor(Color("backgroundColor"))
                Spacer()
            }.padding(.leading, 30)
        }
        .frame(width: 350)
    }
}

struct ButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
        ButtonComponent(title: "teste")
    }
}

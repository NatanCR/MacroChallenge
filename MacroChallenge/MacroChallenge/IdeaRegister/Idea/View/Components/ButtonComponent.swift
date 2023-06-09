//
//  ButtonComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 09/06/23.
//

import SwiftUI

struct ButtonComponent: View {
    
    var title: String
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 350, height: 70)
                .foregroundColor(Color("AccentColor"))
            HStack{
                Text(title)
                    .font(Font.custom("Sen-Regular", size: 20))
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

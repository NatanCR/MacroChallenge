//
//  TextPreviewView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct TextPreviewComponent: View {
    var text: String
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("backgroundItem"))
                    .frame(width: 100, height: 100)
                Text(text)
                    .foregroundColor(Color("labelColor"))
                    .font(Font.custom("Sen-Regular", size: 17))
                    .frame(width: 80, height: 80)
                
            }
            Text("Title")
                .font(.custom("Sen-Regular", size: 20))
            Text("Description")
                .font(.custom("Sen-Regular", size: 15))
        }
    }
}

struct TextPreviewComponent_Previews: PreviewProvider {
    static var previews: some View {
        TextPreviewComponent(text: "")
    }
}

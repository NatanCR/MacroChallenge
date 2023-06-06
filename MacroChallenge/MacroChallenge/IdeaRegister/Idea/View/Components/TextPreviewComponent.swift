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
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color("backgroundItem"))
                .frame(width: 100, height: 100)
            Text(text)
                .foregroundColor(Color("labelColor"))
                .font(Font.custom("Sen-Regular", size: 17))
                .frame(width: 80, height: 80)
            
        }
    }
}

struct TextPreviewComponent_Previews: PreviewProvider {
    static var previews: some View {
        TextPreviewComponent(text: "")
    }
}

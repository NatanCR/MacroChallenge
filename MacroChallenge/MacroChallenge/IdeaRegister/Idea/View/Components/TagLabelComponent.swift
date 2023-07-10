//
//  TagLabelComponent.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 10/07/23.
//

import SwiftUI

struct TagLabelComponent: View {
    var tagName: String
    
    var body: some View {
            Text(tagName)
                .font(.custom("Sen-Regular", size: 16))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                    //TODO: deixar o usuário escolher a cor
                        .fill(Color("labelColor"))
                )
                .foregroundColor(Color("backgroundColor"))
                .lineLimit(1)
    }
}

struct TagLabelComponent_Previews: PreviewProvider {
    static var previews: some View {
        TagLabelComponent(tagName: "Tag")
    }
}

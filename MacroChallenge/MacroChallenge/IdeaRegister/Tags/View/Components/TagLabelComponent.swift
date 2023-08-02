//
//  TagLabelComponent.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 10/07/23.
//

import SwiftUI

struct TagLabelComponent: View {
    var tagName: String
    var isSelected: Bool
    
    var body: some View {
            Text(tagName)
                .font(.custom("Sen-Regular", size: 16))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color("labelColor") : Color.clear)
                )
                .overlay {
                    Capsule()
                    .stroke(isSelected ? Color.clear : Color("labelColor"), lineWidth: 1)
                }
                
                .foregroundColor(isSelected ? Color("backgroundColor") : Color("labelColor"))
                .lineLimit(1)
    }
}

//struct TagLabelComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        TagLabelComponent(tagName: "Extraterrestre", isSelected: Binding(false))
//    }
//}

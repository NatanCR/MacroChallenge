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
    @State var colorName: String // recebe a cor da tag se precisar mudar na view da ideia
    
    var body: some View {
            Text(tagName)
                .font(.custom("Sen-Regular", size: 16))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                    //se colorName estiver vazio, apresenta cor padrão
                        .fill(isSelected ? Color(colorName.isEmpty ? "labelColor" : colorName) : Color.clear)
                )
                .overlay {
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color(colorName.isEmpty ?  "labelColor" : colorName), lineWidth: 1)
                }
                
                .foregroundColor(isSelected ? Color("backgroundColor") : Color(colorName.isEmpty ? "labelColor" : colorName))
                .lineLimit(1)
    }
}

//struct TagLabelComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        TagLabelComponent(tagName: "Extraterrestre", isSelected: Binding(false))
//    }
//}

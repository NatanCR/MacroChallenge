//
//  HorizontalTagScrollComponent.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 09/08/23.
//

import SwiftUI

struct HorizontalTagScrollComponent: View {
    
    @Environment(\.screenSize) var screenSize
    var tags: [Tag]
    
    var body: some View {
            ZStack(alignment: .trailing) {
                
                ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            ForEach(tags, id: \.self) { tag in
                                TagLabelComponent(tagName: tag.name, isSelected: tag.isTagSelected, colorName: tag.color)
                            }
                        }

                }
                Rectangle()
                    .fill(LinearGradient(
                        stops: [
                        Gradient.Stop(color: Color("gradient"), location: 0.00),
                        Gradient.Stop(color: Color("gradient").opacity(0), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 1, y: 0.5),
                        endPoint: UnitPoint(x: 0, y: 0.5)
                        ))
                    .frame(width: screenSize.width * 0.1, height: screenSize.height * 0.08)
            }
    }
}

//struct HorizontalTagScrollComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        HorizontalTagScrollComponent()
//    }
//}

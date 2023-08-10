//
//  HorizontalTagScrollComponent.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 09/08/23.
//

import SwiftUI

struct HorizontalTagScrollComponent<T: Idea>: View {
    @Environment(\.screenSize) var screenSize
    var idea: T
    
    var body: some View {
            ZStack(alignment: .trailing) {
                
                ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            ForEach(idea.tag ?? [], id: \.self) { tag in
                                TagLabelComponent(tagName: tag.name, isSelected: tag.isTagSelected)
                            }
                        }
                }
                Rectangle()
                    .fill(LinearGradient(
                        stops: [
                        Gradient.Stop(color: Color("backgroundColor"), location: 0.00),
                        Gradient.Stop(color: Color("backgroundColor").opacity(0), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 1, y: 0.5),
                        endPoint: UnitPoint(x: 0, y: 0.5)
                        ))
                    .frame(width: screenSize.width * 0.1, height: screenSize.height * 0.06)
            }
    }
}

//struct HorizontalTagScrollComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        HorizontalTagScrollComponent()
//    }
//}

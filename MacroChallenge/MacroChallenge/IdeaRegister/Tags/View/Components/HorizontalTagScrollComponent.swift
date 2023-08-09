//
//  HorizontalTagScrollComponent.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 09/08/23.
//

import SwiftUI

struct HorizontalTagScrollComponent: View {
    @Environment(\.screenSize) private var screenSize
    @State var ideaTags: [Tag]
    @Binding var activeSheet: Bool
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(ideaTags, id: \.self) { tag in
                    Button {
                        self.activeSheet = true
                    } label: {
                        TagLabelComponent(tagName: tag.name, isSelected: tag.isTagSelected)
                    }
//                    .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.7)
                }
            }
        }
    }
}

//struct HorizontalTagScrollComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        HorizontalTagScrollComponent()
//    }
//}

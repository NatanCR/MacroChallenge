//
//  PlaceholderComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 15/06/23.
//

import SwiftUI

struct PlaceholderComponent<T: Idea>: View {
    var idea: T
    var body: some View {
        
        Text(self.idea.textComplete.isEmpty ? "typeNote" : "")
            .font(.custom("Sen-Regular", size: 17))
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(8)
            .foregroundColor(Color("labelColor"))
            .opacity(0.6)    }
}

//struct PlaceholderComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceholderComponent()
//    }
//}

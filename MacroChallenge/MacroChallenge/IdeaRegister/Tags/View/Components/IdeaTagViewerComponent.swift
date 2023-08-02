//
//  IdeaTagViewerComponent.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 10/07/23.
//

import SwiftUI

struct IdeaTagViewerComponent<T: Idea>: View {
    var idea: T
    
    var body: some View {
        
        if idea.tag!.count > 0 && idea.tag!.count < 2  {
            TagLabelComponent(tagName: idea.tag?.first?.name ?? "", isSelected: true)
            
        } else if idea.tag!.count >= 2 {
            ZStack {
                //segunda
                TagLabelComponent(tagName: idea.tag?.first?.name ?? "", isSelected: true)
                //primeira
                TagLabelComponent(tagName: idea.tag?.first?.name ?? "", isSelected: true)
                    .offset(x: -5, y: -5)
            }
        }
    }
}

//struct IdeaTagViewerComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        IdeaTagViewerComponent()
//    }
//}

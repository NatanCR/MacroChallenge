//
//  IdeaDateTitleComponent.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 08/08/23.
//

import SwiftUI

struct IdeaDateTitleComponent<T: Idea>: View {
    @State var itsBySorted: Bool = true
    @State var willBeByCreation: Bool
    @State var idea: T
    
    var body: some View {
        Button {
            self.itsBySorted = false
            if !itsBySorted {
                self.willBeByCreation.toggle()
            }
        } label: {
            if itsBySorted {
                HStack {
                    Text(willBeByCreation ? "ideaCreate" : "ideaEdit")
                    Text(willBeByCreation ? idea.creationDate.toString(dateFormatter: IdeasViewModel.dateFormatter)! : idea.modifiedDate.toString(dateFormatter: IdeasViewModel.dateFormatter)!)
                    Text(willBeByCreation ? idea.creationDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())! : idea.modifiedDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())!)
                }
            } else {
                if !self.willBeByCreation {
                    //edicao
                        Text("ideaEdit")
                        Text(idea.modifiedDate.toString(dateFormatter: IdeasViewModel.dateFormatter)!)
                        Text(idea.modifiedDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())!)
                } else {
                    //criacao
                    Text("ideaCreate")
                    Text(idea.creationDate.toString(dateFormatter: IdeasViewModel.dateFormatter)!)
                    Text(idea.creationDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())!)
                }
            }
        }.font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
            .foregroundColor(Color("labelColor"))
            .opacity(0.8)
    }
}

//struct IdeaDateTitleComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        IdeaDateTitleComponent()
//    }
//}

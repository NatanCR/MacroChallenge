//
//  TextPreviewView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct TextPreviewComponent: View {
    @Environment(\.screenSize) var screenSize
    private let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    var text: String
    var title: String
    @Binding var idea: any Idea
    @ObservedObject var ideasViewModel: IdeasViewModel
    
    init(text: String, title: String, idea: Binding<any Idea>, ideasViewModel: IdeasViewModel) {
        self.text = text
        self.title = title
        self._idea = idea
        self.ideasViewModel = ideasViewModel
    }
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("backgroundItem"))
                    .frame(width: screenSize.width * 0.29, height: screenSize.width * 0.29)
                    .overlay(alignment: .topTrailing){
                        ButtonFavoriteComponent(type: ModelText.self, idea: $idea.wrappedValue as! ModelText)
                        .padding(8)
                    }
                Text(text)
                    .foregroundColor(Color("labelColor"))
                    .font(Font.custom("Sen-Regular", size: 17, relativeTo: .headline))
                    .frame(width: screenSize.width * 0.25, height: screenSize.width * 0.15)
                
            }
            .padding(.bottom, 5)
            
            Text(title)
                .font(.custom("Sen-Regular", size: 20, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.02)
            Text(self.ideasViewModel.isSortedByCreation ? idea.creationDate.toString(dateFormatter: self.dateFormatter)! : idea.modifiedDate.toString(dateFormatter: self.dateFormatter)!)
                .font(Font.custom("Sen-Regular", size: 17, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.02)
            
            
        }
    }
}

//struct TextPreviewComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        TextPreviewComponent(text: "", title: "", editDate: Date(), idea: )
//    }
//}

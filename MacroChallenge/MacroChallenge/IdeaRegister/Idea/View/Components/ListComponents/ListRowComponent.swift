//
//  ListRowComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 07/06/23.
//

import SwiftUI

struct ListRowComponent: View {
    @Environment(\.screenSize) var screenSize
    @ObservedObject var ideasViewModel: IdeasViewModel
    @State private var isAlertActive: Bool = false
    @Binding var idea: any Idea
    var title: String
    var typeIdea: IdeaType
    var imageIdea: UIImage
    private let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    
    var body: some View {
        HStack{

            if typeIdea == .audio {
                Image("list_audio")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .cornerRadius(5)
                    .padding(.trailing)
                
            } else if typeIdea == .photo {
                Image(uiImage: imageIdea)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .rotationEffect(.degrees(90))
                    .cornerRadius(5)
                    .padding(.trailing)

            } else {
                Image("list_text")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .cornerRadius(5)
                    .padding(.trailing)
            }
            
            VStack(alignment: .leading){
                Text(title)
                    .font(Font.custom("Sen-Bold", size: 20, relativeTo: .headline))
                    .foregroundColor(Color("labelColor"))
                    .frame(maxWidth: screenSize.width * 0.4, maxHeight: screenSize.height * 0.008, alignment: .leading)
                    .padding(.bottom, 10)
                HStack{
                    Text(ideasViewModel.isSortedByCreation ? idea.creationDate.toString(dateFormatter: self.dateFormatter)! : idea.modifiedDate.toString(dateFormatter: self.dateFormatter)!)
                        .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                        .foregroundColor(Color("labelColor"))
                        .opacity(0.5)
                        .frame(maxWidth: screenSize.width * 0.4, maxHeight: screenSize.height * 0.008, alignment: .leading)
                    Text(ideasViewModel.isSortedByCreation ? idea.creationDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())! : idea.modifiedDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())!)
                        .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                        .foregroundColor(Color("labelColor"))
                        .opacity(0.5)
                        .frame(maxWidth: screenSize.width * 0.4, maxHeight: screenSize.height * 0.008, alignment: .leading)
                    
                }
            }
            
        }
        .padding([.top, .bottom], 25)
        .padding(.leading, 5)


        //arrastar para deletar e para favoritar na lista
        .swipeActions(edge: .trailing) {
            
            Button(role: .destructive) {
                print("delete")
                switch typeIdea {
                case .text:
                    IdeaSaver.clearOneIdea(type: ModelText.self, idea: idea as! ModelText)
                case .audio:
                    IdeaSaver.clearOneIdea(type: AudioIdea.self, idea: idea as! AudioIdea)
                case .photo:
                    IdeaSaver.clearOneIdea(type: PhotoModel.self, idea: idea as! PhotoModel)
                }
                self.ideasViewModel.updateSectionIdeas()
                
            } label: {
                Image(systemName: "trash.fill")
            }
            .tint(Color("deleteColor"))
            
        }
        
        .swipeActions(edge: .leading) {
            Button {
                print("fav")
                idea.isFavorite.toggle()
                switch typeIdea {
                case .text:
                    IdeaSaver.changeSavedValue(type: ModelText.self, idea: idea as! ModelText)
                case .audio:
                    IdeaSaver.changeSavedValue(type: AudioIdea.self, idea: idea as! AudioIdea)
                case .photo:
                    IdeaSaver.changeSavedValue(type: PhotoModel.self, idea: idea as! PhotoModel)
                }
            } label: {
                Image(systemName: "star")
            }
            .tint(Color("tagColor3"))
        }
        
    }
}

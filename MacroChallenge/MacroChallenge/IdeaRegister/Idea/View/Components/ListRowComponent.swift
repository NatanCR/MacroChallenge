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
            VStack(alignment: .leading){
                Text(title)
                    .font(Font.custom("Sen-Regular", size: 20, relativeTo: .headline))
                    .foregroundColor(Color("labelColor"))
                    .frame(maxWidth: screenSize.width * 0.4, maxHeight: screenSize.height * 0.01, alignment: .leading)
                    .padding(.bottom, 5)
                
                Text(ideasViewModel.isSortedByCreation ? idea.creationDate.toString(dateFormatter: self.dateFormatter)! : idea.modifiedDate.toString(dateFormatter: self.dateFormatter)!)
                    .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                    .foregroundColor(Color("labelColor"))
                    .opacity(0.5)
                    .frame(maxWidth: screenSize.width * 0.4, maxHeight: screenSize.height * 0.01, alignment: .leading)
            }
            
            Spacer()
            if typeIdea == .audio {
                Image(uiImage: UIImage(systemName: "waveform.and.mic") ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .cornerRadius(5)
                
            } else if typeIdea == .photo {
                Image(uiImage: imageIdea)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .cornerRadius(5)
                    .rotationEffect(.degrees(90))
            } else {
                
            }
        }
        .padding([.top, .bottom])
        //arrastar para deletar e para favoritar na lista
        .swipeActions(edge: .trailing) {
            //TODO: atualizar a view assim que deleta a ideia
            Button(role: .destructive) {
                switch typeIdea {
                case .text:
                    IdeaSaver.clearOneIdea(type: ModelText.self, idea: idea as! ModelText)
                case .audio:
                    IdeaSaver.clearOneIdea(type: AudioIdea.self, idea: idea as! AudioIdea)
                case .photo:
                    IdeaSaver.clearOneIdea(type: PhotoModel.self, idea: idea as! PhotoModel)
                }
                self.ideasViewModel.resetDisposedData()
                
            } label: {
                Image(systemName: "trash.fill")
            }
            .tint(Color("deleteColor"))
            
        }
        
        .swipeActions(edge: .leading) {
            Button {
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
                Image(systemName: "heart")
            }
            .tint(Color("splashScreen"))
        }
        
    }
}

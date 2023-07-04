//
//  ImagePreviewComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct ImagePreviewComponent: View {
    @Environment(\.screenSize) var screenSize
    private let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    var image: UIImage
    var title: String
    @State var idea: any Idea
    @ObservedObject var ideasViewModel: IdeasViewModel
    @State private var isAlertActive: Bool = false

    
    var body: some View {
        VStack{
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .opacity(0.8)
                .frame(width: screenSize.width * 0.29, height: screenSize.width * 0.29)
                .cornerRadius(20)
                .rotationEffect(.degrees(90))
                .overlay(content: {
                    Rectangle()
                        .cornerRadius(20)
                        .foregroundColor(Color("backgroundColor"))
                        .opacity(0.35)
                        .blur(radius: 2)
                })
                .overlay(alignment: .topTrailing){
                    Button{
                        idea.isFavorite.toggle()
                        switch idea.ideiaType {
                        case .audio:
                            IdeaSaver.changeSavedValue(type: AudioIdeia.self, idea: idea as! AudioIdeia)
                        case .text:
                            IdeaSaver.changeSavedValue(type: ModelText.self, idea: idea as! ModelText)
                        case .photo:
                            IdeaSaver.changeSavedValue(type: PhotoModel.self, idea: idea as! PhotoModel)
                        }
                    } label: {
                        idea.isFavorite ? Image(systemName: "heart.fill").font(.system(size: 20)) : Image(systemName: "heart").font(.system(size: 20))
                    }
                    .padding(8)
                }
                .padding(.bottom, 5)
                .contextMenu{
                    Button(role: .destructive){
                        isAlertActive = true
                    } label: {
                        HStack{
                            Text("del")
                            Image(systemName: "trash")
                        }
                    }
                }
            Text(title)
                .font(Font.custom("Sen-Regular", size: 17, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.02)
                
            
            Text(self.ideasViewModel.isSortedByCreation ? idea.creationDate.toString(dateFormatter: self.dateFormatter)! : idea.modifiedDate.toString(dateFormatter: self.dateFormatter)!)
                .font(Font.custom("Sen-Regular", size: 17, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.02)
        }
        
        //TODO: fazer a tradução do alerta
        .confirmationDialog("Do you really want to do this?", isPresented: $isAlertActive) {
            Button("Delete Idea", role: .destructive) {
                //TODO: atualizar a view assim que deleta a ideia
                //deletar
                IdeaSaver.clearOneIdea(type: PhotoModel.self, idea: idea as! PhotoModel)
                
                if let photoIdea = idea as? PhotoModel {
                    ContentDirectoryHelper.deleteAudioFromDirectory(audioPath: photoIdea.capturedImages)
                }

            }
        }
    }
}

//struct ImagePreviewComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePreviewComponent(image: UIImage(), title: "", editDate: Date())
//    }
//}

//
//  ImagePreviewComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct ImagePreviewComponent: View {
    @Environment(\.screenSize) var screenSize
    var image: UIImage
    var title: String
    @State var idea: any Idea
    @ObservedObject var ideasViewModel: IdeasViewModel
    @State private var isAlertActive: Bool = false
    @Binding var isAdding: Bool

    
    var body: some View {
        VStack{
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .opacity(0.8)
                .frame(width: screenSize.width * 0.26, height: screenSize.width * 0.26)
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

                    OverlayComponent(type: PhotoModel.self, text: "", idea: idea as! PhotoModel, isAdding: $isAdding)
                    .padding(8)
                }
                .padding(.bottom, 5)
            
            //deletar
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
                .font(Font.custom("Sen-Bold", size: 17, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
            Text(self.ideasViewModel.isSortedByCreation ? idea.creationDate.toString(dateFormatter: IdeasViewModel.dateFormatter)! : idea.modifiedDate.toString(dateFormatter: IdeasViewModel.dateFormatter)!)
                .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
            Text(self.ideasViewModel.isSortedByCreation ? idea.creationDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())! : idea.modifiedDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())!)
                .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
        }
        
        .confirmationDialog("delMsg", isPresented: $isAlertActive) {
            Button("delIdea", role: .destructive) {
                //TODO: atualizar a view assim que deleta a ideia
                //deletar
                IdeaSaver.clearOneIdea(type: PhotoModel.self, idea: idea as! PhotoModel)
                self.ideasViewModel.resetDisposedData()
                
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

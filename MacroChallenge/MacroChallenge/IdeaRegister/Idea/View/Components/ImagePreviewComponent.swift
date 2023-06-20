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
    var editDate: Date
    @State var idea: any Idea
    
    var body: some View {
        VStack{
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: screenSize.width * 0.29, height: screenSize.width * 0.29)
                .cornerRadius(20)
                .rotationEffect(.degrees(90))
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
            Text(title)
                .font(Font.custom("Sen-Regular", size: 17, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.02)
                
            
            Text(editDate.toString(dateFormatter: self.dateFormatter)!)
                .font(Font.custom("Sen-Regular", size: 17, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.02)
        }
    }
}

//struct ImagePreviewComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePreviewComponent(image: UIImage(), title: "", editDate: Date())
//    }
//}

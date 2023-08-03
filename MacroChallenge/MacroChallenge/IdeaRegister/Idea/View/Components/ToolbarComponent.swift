//
//  ToolbarComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct ToolbarComponent: View {
    
    @ObservedObject var ideasViewModel: IdeasViewModel
    var photoModel: PhotoModel
    
    init(ideasViewModel: IdeasViewModel) {
        self.ideasViewModel = ideasViewModel
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = UUID().uuidString + ".png"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let lastComponent = fileURL.lastPathComponent
        self.photoModel = PhotoModel(title: "", description: "", textComplete: "", creationDate: Date(), modifiedDate: Date(), capturedImage: lastComponent, tag: [])
    }
    var body: some View {
        HStack{
            
            NavigationLink{
                InsertPhotoIdeaView(ideasViewModel: ideasViewModel, photoModel: photoModel)
            } label: {
                Image(systemName: "camera.fill")
            }
            .padding()
            Spacer()
            NavigationLink {
                RecordAudioView(ideasViewModel: ideasViewModel)
            } label: {
                Image(systemName: "mic.fill")
            }
            Spacer()
            NavigationLink {
                TextRegisterView(ideasViewModel: ideasViewModel)
            } label: {
                Image(systemName: "square.and.pencil")
            }.padding()
        }
    }
}

//struct ToolbarComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        ToolbarComponent(isShowingCamera: false)
//    }
//}

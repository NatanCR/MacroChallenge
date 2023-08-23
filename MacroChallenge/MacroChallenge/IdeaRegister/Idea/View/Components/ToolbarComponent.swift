//
//  ToolbarComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct ToolbarComponent: View {
    
    @ObservedObject var ideasViewModel: IdeasViewModel
    @State var photoModel: PhotoModel = PhotoModel(title: "", description: "", textComplete: "", creationDate: Date(), modifiedDate: Date(), capturedImage: "", tag: [], grouped: false)
    @State var tookPicture: Bool = false
    
    init(ideasViewModel: IdeasViewModel) {
        self.ideasViewModel = ideasViewModel
    }
    
    var body: some View {
        HStack{
            Button {
                ideasViewModel.isShowingCamera = true
            } label: {
                Image(systemName: "camera.fill")
            }
            .fullScreenCover(isPresented: $ideasViewModel.isShowingCamera) {
                CameraRepresentable(tookPicture: $tookPicture, photoModel: $photoModel, viewModel: ideasViewModel.cameraViewModel)
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
            }
            
            NavigationLink("", destination: PhotoIdeaView(photoModel: photoModel, viewModel: ideasViewModel), isActive: $tookPicture)
        }
    }
}

//struct ToolbarComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        ToolbarComponent(isShowingCamera: false)
//    }
//}

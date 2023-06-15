//
//  ToolbarComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct ToolbarComponent: View {
    @ObservedObject var ideasViewModel: IdeasViewModel
//    @State var isShowingCamera = false
    
    var body: some View {
        HStack{
            Button {
                ideasViewModel.isShowingCamera = true
            } label: {
                Image(systemName: "camera.fill")
            }
            .fullScreenCover(isPresented: $ideasViewModel.isShowingCamera) {
                CameraRepresentable(viewModel: ideasViewModel.cameraViewModel)
            }
            .padding()
            Spacer()
            NavigationLink {
                RecordAudioView()
            } label: {
                Image(systemName: "mic.fill")
            }
            Spacer()
            NavigationLink {
                TextRegisterView()
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

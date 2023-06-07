//
//  CapturePhotoView.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Rodrigo Ferreira Pereira on 25/05/23.
//

import SwiftUI

struct CapturePhotoView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var isShowingCamera = false

    var body: some View {
        VStack {
            Button("Abrir Câmera") {
                isShowingCamera = true
            }
            .sheet(isPresented: $isShowingCamera) {
                CameraRepresentable(viewModel: viewModel)
            }
        }
    }
}


//struct CameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        CapturePhotoView()
//    }
//}

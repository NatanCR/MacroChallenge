//
//  CameraView.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Rodrigo Ferreira Pereira on 25/05/23.
//

import SwiftUI

struct CameraView: View {
    @State private var isShowingCamera = false
    @State private var capturedImages: [UIImage] = []

    var body: some View {
        VStack {
            Button("Abrir Câmera") {
                isShowingCamera = true
            }
            .sheet(isPresented: $isShowingCamera) {
                CameraRepresentable(capturedImages: $capturedImages)
            }
            
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(capturedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    }
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

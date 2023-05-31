//
//  PhotoSavedView.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 31/05/23.
//

import SwiftUI

struct PhotoSavedView: View {
    @State private var savedPhotos = IdeaSaver.getSavedUniqueIdeasType(type: PhotoModel.self, key: IdeaSaver.getPhotoModelKey())
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(savedPhotos, id: \.id) { photo in
                    if let uiImage = UIImage(data: photo.capturedImages.first ?? Data()) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .rotationEffect(.degrees(90))
                            .frame(width: 200, height: 200)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
        .onAppear {
            savedPhotos = IdeaSaver.getSavedUniqueIdeasType(type: PhotoModel.self, key: IdeaSaver.getPhotoModelKey())
        }
    }
}

//struct PhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoView()
//    }
//}

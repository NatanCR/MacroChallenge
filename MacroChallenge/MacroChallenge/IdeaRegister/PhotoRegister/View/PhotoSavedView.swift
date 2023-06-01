//
//  PhotoSavedView.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 31/05/23.
//

import SwiftUI

struct PhotoSavedView: View {
    @State private var savedPhotos = IdeaSaver.getSavedUniqueIdeasType(type: PhotoModel.self, key: IdeaSaver.getPhotoModelKey())
    
    private let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
//                Color.clear
                
                if let lastPhoto = savedPhotos.last {
                    if let uiImage = UIImage(data: lastPhoto.capturedImages.first ?? Data()) {
                        VStack {
                            Text("Ideia do dia \(lastPhoto.creationDate, formatter: self.dateFormat)")
                                .bold()
                                .font(.system(size: 25))
                            
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .rotationEffect(.degrees(90))
                                .frame(width: geometry.size.width+120)
                                .position(x: geometry.size.width/2, y: geometry.size.height/2.5)
                        }
                    }
                }
            }
        }
        .onAppear {
            savedPhotos = IdeaSaver.getSavedUniqueIdeasType(type: PhotoModel.self, key: IdeaSaver.getPhotoModelKey())
        }
    }
}


struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSavedView()
    }
}

//
//  PhotoIdeaView.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 31/05/23.
//

import SwiftUI

struct PhotoIdeaView: View {
    @State private var savedPhotos = IdeaSaver.getSavedUniqueIdeasType(type: PhotoModel.self, key: IdeaSaver.getPhotoModelKey())
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    
    private let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let lastPhoto = savedPhotos.last {
                    if let uiImage = UIImage(data: lastPhoto.capturedImages.first ?? Data()) {
                        VStack {
                            HStack {
                                
                                Text("Ideia do dia \(lastPhoto.creationDate, formatter: self.dateFormat)")
                                    .bold()
                                    .font(.system(size: 25))
                                Spacer()
                            }
                            
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
        .navigationBarItems(trailing: Button(action: {
            if let lastPhoto = savedPhotos.last {
                IdeaSaver.clearOneIdea(type: PhotoModel.self, idea: lastPhoto)
            }
            showAlert = true
        }) {
            Image(systemName: "trash")
                .foregroundColor(.red)
        })
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Sucesso"),
                message: Text("A ideia foi excluída com sucesso."),
                dismissButton: .default(Text("OK")) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onAppear {
            savedPhotos = IdeaSaver.getSavedUniqueIdeasType(type: PhotoModel.self, key: IdeaSaver.getPhotoModelKey())
        }
    }
}


//struct PhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoIdeaView()
//    }
//}

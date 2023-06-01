//
//  PhotoHomeView.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 31/05/23.
//

import SwiftUI

struct PhotoHomeView: View {
    var body: some View {
        NavigationView {
            HStack {
                NavigationLink(destination: CapturePhotoView()) {
                    Text("Add Photo")
                }
                .padding(10)
                
                NavigationLink(destination: PhotoSavedView()) {
                    Text("Saved Photos")
                }
            }
            .navigationBarTitle("Photo Home")
        }
//        .onAppear {
//            dump(IdeaSaver.getSavedUniqueIdeasType(type: PhotoModel.self, key: IdeaSaver.getPhotoModelKey()))
//        }
    }
}

struct PhotoHomeView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoHomeView()
    }
}

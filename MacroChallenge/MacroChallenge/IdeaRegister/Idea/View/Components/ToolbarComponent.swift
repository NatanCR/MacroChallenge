//
//  ToolbarComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct ToolbarComponent: View {
    @StateObject private var viewModel = CameraViewModel()
    @State var isShowingCamera: Bool
    
    var body: some View {
        HStack{
            Button {
                isShowingCamera = true
            } label: {
                Image(systemName: "camera.fill")
            }
            .sheet(isPresented: $isShowingCamera) {
                CameraRepresentable(viewModel: viewModel)
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

struct ToolbarComponent_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarComponent(isShowingCamera: false)
    }
}

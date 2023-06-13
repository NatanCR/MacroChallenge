//
//  ToolbarComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct ToolbarComponent: View {
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some View {
        HStack{
            NavigationLink {
                CameraRepresentable(viewModel: viewModel)
            } label: {
                Image(systemName: "camera.fill")
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
        ToolbarComponent()
    }
}

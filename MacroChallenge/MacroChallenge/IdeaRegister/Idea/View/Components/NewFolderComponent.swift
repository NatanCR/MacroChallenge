//
//  NewFolderComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/07/23.
//

import SwiftUI

struct NewFolderComponent: View {
//    @Environment(\.editMode) var editMode
    @Binding var isAdding: Bool
    @ObservedObject var ideasViewModel: IdeasViewModel
    
    var body: some View {
        HStack{
            Spacer()
            
            Button{
                isAdding = true
            } label: {
                HStack{
                    Image(systemName: "folder.badge.plus")
                    //TODO: localizar texto
                    Text("newFolder")
                        .font(.custom("Sen-Regular", size: 17))
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

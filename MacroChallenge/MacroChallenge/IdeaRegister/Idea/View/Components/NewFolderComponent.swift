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
    
    var body: some View {
        HStack{
            Spacer()
            
            Button{
                isAdding = true
                print("ta passando aqui")
            } label: {
                HStack{
                    Image(systemName: "folder.badge.plus")
                    //TODO: localizar texto
                    Text("New Folder")
                        .font(.custom("Sen-Regular", size: 17))
                }
            }
            .padding(.horizontal, 20)
        }
    }
}


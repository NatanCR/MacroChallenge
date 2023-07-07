//
//  FolderView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/07/23.
//

import SwiftUI

struct FolderView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.screenSize) var screenSize
    @State var text: String = "Untitled"
    @Binding var isAdding: Bool
    @FocusState var isFocused: Bool

    var body: some View {
        VStack{
            TextField("Folder Name", text: $text)
                .font(.custom("Sen-Bold", size: 30))
                .padding()
                .focused($isFocused)
            ScrollView{
                //TODO: apresentar ideias da pasta
                Rectangle()
                    .fill(Color("backgroundColor"))
                    .frame(width: screenSize.width, height: screenSize.height * 0.8)
            }
        }.navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                //                MenuEditComponent(type: , idea: )
                Button{
                    
                } label: {
                    Image(systemName: "ellipsis.circle")
                }

            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if isFocused{
                    Button{
                        isFocused = false
                    } label: {
                        Text("OK")
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                //TODO: transformar isAdding em false quando arrastar para voltar
                //back button
                Button{
                    if isAdding{
                        isAdding = false
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .background(Color("backgroundColor"))
    }
}

//struct FolderView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderView()
//    }
//}

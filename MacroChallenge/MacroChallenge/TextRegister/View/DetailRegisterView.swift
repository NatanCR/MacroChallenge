//
//  DetailRegisterView.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Natan de Camargo Rodrigues on 25/05/23.
//

import SwiftUI

struct DetailRegisterView: View {
    @State private var isEditing = false // Variável de estado para controlar se a tela de edição está sendo exibida
    var model: Model
    @ObservedObject var modelData: ModelData
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            List {
                Section {
                    Text("\(model.title)")
                } header: {
                    Text("Title:")
                }
                
                Section {
                    Text("\(model.text)")
                } header: {
                    Text("Idea:")
                }
            }
            
            Spacer()
            NavigationLink {
                EditRegisterView(model: model, modelData: modelData)
            } label: {
                Text("Edit")
            }
        }.padding()
    }
}

//struct DetailRegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailRegisterView()
//    }
//}

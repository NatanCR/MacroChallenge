//
//  ListView.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 30/05/23.
//

import SwiftUI

struct ListView: View {
    @StateObject private var modelData = ModelData() //variável que envia os dados para o objeto da estrutura
    let userDefaults = UserDefaultsManager()
    @EnvironmentObject var appState: AppState
    
    
    var body: some View {
        NavigationView {
            VStack {
                List(modelData.model, id: \.id) { model in
                    NavigationLink {
//                        DetailRegisterView(modelText: model, modelData: modelData)
                        EditRegisterView(modelText: model, modelData: modelData)
                    } label: {
                        CellTemplate(model: model)
                    }
                }
                NavigationLink {
                    TextRegisterView(modelData: modelData)
                } label: {
                    Text("Register Idea")
                }
            }
            .padding()
            .onAppear {
                //carrega a lista toda vez que a tela é aberta
                if let loadedModel = userDefaults.decoderModel() {
                    modelData.model = loadedModel
                }
            }
        }
        //aciona o comportamento popToRootView
        .id(appState.rootViewId)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

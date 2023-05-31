//
//  EditRegisterView.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Natan de Camargo Rodrigues on 25/05/23.
//

import SwiftUI

struct EditRegisterView: View {
    private let height = UIScreen.main.bounds.size.height //trocar pelo geometry
    @State var model: ModelText
    @Environment(\.dismiss) private var dismiss
    private let userDefaultsManager = UserDefaultsManager()
    @ObservedObject var modelData: ModelData
    @State private var isAlertActive: Bool = false
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            TextField("Title", text: $model.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextEditor(text: $model.text)
                .frame(height: height * 0.2)
                .padding()
            
            //salva e fecha a tela de edição
            Button("Save") {
                //verifica ID atual e localiza no array
                if let index = modelData.model.firstIndex(where: { $0.id == model.id }) {
                    //atualiza o dado na posição no indice
                    modelData.model[index] = model
                    //salva novamente
                    userDefaultsManager.encoderModel(model: modelData.model)
                    //fecha a tela
                    dismiss()
                }
            }
            .padding()
            Spacer()
            Button(role: .destructive) {
                self.isAlertActive.toggle()
            } label: {
                Text("Delete")
                    .foregroundColor(.red)
            }
            .padding()
            .confirmationDialog("Do you really want to do this?", isPresented: $isAlertActive) {
                Button("Delete Idea", role: .destructive) {
                    userDefaultsManager.deleteModel(withID: model.id)
                    appState.rootViewId = UUID()
                }
            }
        }
    }
}
    
    //struct EditRegisterView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        EditRegisterView()
    //    }
    //}

//
//  EditRegisterView.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Natan de Camargo Rodrigues on 25/05/23.
//

import SwiftUI

struct EditRegisterView: View {
    @State var modelText: ModelText
    @Environment(\.dismiss) private var dismiss
    private let userDefaultsManager = UserDefaultsManager()
    @ObservedObject var modelData: ModelData
    @State private var isAlertActive: Bool = false
    @EnvironmentObject var appState: AppState
//    @State private var completeText: String
    
    var body: some View {
        GeometryReader { geo in
            VStack {
    //            TextField("Title", text: $modelText.title)
    //                .textFieldStyle(RoundedBorderTextFieldStyle())
    //                .padding()
                
                TextEditor(text: $modelText.textComplete)
                    .frame(height: geo.size.height * 0.2)
                    .padding()
                
                //salva e fecha a tela de edição
                Button("Save") {
                    //verifica ID atual e localiza no array
                    if let index = modelData.model.firstIndex(where: { $0.id == modelText.id }) {
                        //atualiza o dado na posição no indice
                        modelData.model[index] = modelText
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
                        userDefaultsManager.deleteModel(withID: modelText.id)
                        appState.rootViewId = UUID()
                    }
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

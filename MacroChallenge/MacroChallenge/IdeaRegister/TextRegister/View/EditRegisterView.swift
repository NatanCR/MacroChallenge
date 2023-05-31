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
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                TextEditor(text: $modelText.textComplete)
                    .frame(height: geo.size.height * 0.2)
                    .padding()
                
                //salva e fecha a tela de edição
                Button("Save") {
                    //verifica ID atual e localiza no array
                    if let index = modelData.model.firstIndex(where: { $0.id == modelText.id }) {
                        
                        modelText.title = TextViewModel.separateTitleFromText(textComplete: modelText.textComplete, title: modelText.title) ?? String()
                        
                        //remover o título do texto original
                        modelText.text = modelText.textComplete.replacingOccurrences(of: modelText.title, with: ("".trimmingCharacters(in: .whitespacesAndNewlines)))
                                               
                        modelText = ModelText(title: modelText.title, creationDate: modelText.creationDate, modifiedDate: Date(), text: modelText.text, textComplete: modelText.textComplete)
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
                .confirmationDialog("Do you really want to do this?", isPresented: $isAlertActive) {
                    Button("Delete Idea", role: .destructive) {
                        userDefaultsManager.deleteModel(withID: modelText.id)
                        appState.rootViewId = UUID()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.isAlertActive.toggle()
                } label: {
                    Text(Image(systemName: "trash.fill"))
                        .foregroundColor(.red)
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

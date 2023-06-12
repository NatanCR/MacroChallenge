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
                    TextViewModel.setTextsFromIdea(idea: &modelText)
                    modelText.modifiedDate = Date()
                    
                    //salva novamente
                    IdeaSaver.changeSavedValue(type: ModelText.self, idea: modelText)
                    
                    //fecha a tela
                    dismiss()
                }
                .padding()
                Spacer()
                    .confirmationDialog("Do you really want to do this?", isPresented: $isAlertActive) {
                        Button("Delete Idea", role: .destructive) {
                            //deletar
                            IdeaSaver.clearOneIdea(type: ModelText.self, idea: modelText)
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

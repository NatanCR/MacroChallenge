//
//  TextRegisterView.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Natan de Camargo Rodrigues on 25/05/23.
//

import SwiftUI

struct TextRegisterView: View {
    private let height = UIScreen.main.bounds.size.height //trocar pelo geometry
    @ObservedObject var modelData: ModelData //variável que passa os dados registrados à outra variável que acesso o objeto da estrutura
    private let userDefaultsManager = UserDefaultsManager()
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""
    @State private var title: String = ""
    @State private var isActive: Bool = false //variável para ativar o alerta
    
    var body: some View {
        VStack {
            Section {
                TextEditor(text: $text)
                    .frame(height: height * 0.2)
                    .padding()
                    .background(Color.gray.opacity(0.2))
            } header: {
                Text("Put your idea here.")
            }

            TextField("Note a title.", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Spacer()
        }
        .alert("Put your Idea", isPresented: $isActive, actions: {
            Button(role: .cancel) {
            } label: {
                Text("OK")
            }
        }, message: {
            Text("It's necessary insert any idea for save")
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    //verifica se o campo de texto está em branco antes de salvar
                    text = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    if text.isEmpty {
                        self.isActive.toggle()
                    } else {
                        //envia o dados registrados salvos
                        let currentDate = Date()
                        print("HORA DE REGISTRO - \(formatarData(currentDate))")
                        
                        let currentModel = Model(title: title, text: text, dateCreation: currentDate)
                        self.modelData.model.append(currentModel)
                        userDefaultsManager.encoderModel(model: modelData.model)
                        dismiss()
                    }
                    
                } label: {
                    Text("Save")
                }
            }
        }
    }
    
    //formata a data em string com o horario local do device
    func formatarData(_ data: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            formatter.locale = Locale.current
            return formatter.string(from: data)
        }
}

//struct TextRegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        TextRegisterView()
//    }
//}

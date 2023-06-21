//
//  EditRegisterView.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Natan de Camargo Rodrigues on 25/05/23.
//

import SwiftUI

struct EditRegisterView: View {
    private var text: LocalizedStringKey = "ideaDay"
    @State var modelText: ModelText
    @Environment(\.dismiss) private var dismiss
    @Environment(\.screenSize) private var screenSize
    @EnvironmentObject var appState: AppState
    // text
    @FocusState var isFocused: Bool
    let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    
    init(modelText: ModelText) {
        self._modelText = State(initialValue: modelText)
    }
    
    var body: some View {
            VStack {
                TextEditor(text: $modelText.textComplete)
                    .frame(width: screenSize.width * 0.95 ,height: screenSize.height * 0.8)
                    .focused($isFocused)
                    .overlay{
                        PlaceholderComponent(idea: modelText)
                    }
            }
            .navigationBarBackButtonHidden()
            .navigationTitle(Text(text) + Text(modelText.creationDate.toString(dateFormatter: self.dateFormatter)!))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    MenuEditComponent(type: ModelText.self, idea: $modelText)
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
                    CustomBackButtonComponent(type: ModelText.self, idea: $modelText)
                }
            }
    }
}

//struct EditRegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRegisterView()
//    }
//}

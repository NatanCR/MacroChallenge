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
    @Environment(\.screenSize) private var screenSize
    
    @EnvironmentObject var appState: AppState
    
    // text
    @FocusState var isFocused: Bool
        
    // date
    let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    
    var body: some View {
            VStack {
                TextEditor(text: $modelText.textComplete)
                    .frame(width: screenSize.width ,height: screenSize.height * 0.8, alignment: .topLeading)
                    .focused($isFocused)
                    .overlay{
                        PlaceholderComponent(idea: modelText)
                    }
            }
            .navigationBarBackButtonHidden()
            .navigationTitle("Ideia do dia \(modelText.creationDate.toString(dateFormatter: self.dateFormatter)!)")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    MenuEditComponent(type: ModelText.self, idea: modelText)
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

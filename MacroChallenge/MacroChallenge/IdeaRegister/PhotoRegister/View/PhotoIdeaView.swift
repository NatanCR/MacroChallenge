//
//  PhotoIdeaView.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 31/05/23.
//

import SwiftUI

struct PhotoIdeaView: View {
    @State var photoModel: PhotoModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.screenSize) var screenSize
    @State private var showAlert = false
    
    let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    var photoURL: URL? = nil
    
    @FocusState var isFocused: Bool
    
    
    init(photoModel: PhotoModel) {
        self._photoModel = State(initialValue: photoModel)
        
        self.photoURL = ContentDirectoryHelper.getDirectoryContent(contentPath: photoModel.capturedImages)
    }
    
    var body: some View {
            if let uiImage = UIImage(contentsOfFile: photoURL!.path) {
                
                VStack (alignment: .center){
                    
                                        
                    Image(uiImage: uiImage)
                        .resizable()
                        .cornerRadius(25)
                        .scaledToFill()
                        .rotationEffect(.degrees(90))
                        .frame(maxWidth: screenSize.width * 0.5, alignment: .top)
                        .padding([.top, .bottom], 50)
                    
                    TextEditor(text: $photoModel.textComplete)
                        .font(.custom("Sen-Regular", size: 17))
                        .multilineTextAlignment(.leading)
                        .frame(alignment: .topLeading)
                        .focused($isFocused)
                        .overlay {
                            PlaceholderComponent(idea: photoModel)
                        }
                        .onAppear {
                            if !photoModel.textComplete.isEmpty {
                                DispatchQueue.main.async {
                                    // Atualizar a view para exibir o conteúdo existente da variável description
                                    self.photoModel.textComplete = photoModel.textComplete
                                }
                            }
                        }
                        .onChange(of: photoModel.textComplete) { newValue in
                            saveIdea()
                        }
                }
        .navigationTitle("ideaDay" + "\(photoModel.creationDate.toString(dateFormatter: self.dateFormatter)!)")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem (placement: .navigationBarTrailing){
                MenuEditComponent(type: PhotoModel.self, idea: self.$photoModel)
            }
            
            ToolbarItem (placement: .navigationBarTrailing){
                if isFocused{
                    Button{
                        isFocused = false
                    } label: {
                        Text("OK")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                CustomBackButtonComponent(type: PhotoModel.self, idea: $photoModel)
            }
        }

                //TODO: traduzir alerta
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Sucesso"),
                    message: Text("A ideia foi excluída com sucesso."),
                    dismissButton: .default(Text("OK")) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
    
    //MARK: - FUNCs
    private func saveIdea() {
        let text = self.photoModel.textComplete
        if let lastCharacter = text.last, lastCharacter.isWhitespace { return }
        
        self.photoModel.modifiedDate = Date()
        TextViewModel.setTextsFromIdea(idea: &self.photoModel)
        IdeaSaver.changeSavedValue(type: PhotoModel.self, idea: self.photoModel)
    }
}


//struct PhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoIdeaView()
//    }
//}

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
        ZStack {
            if let uiImage = UIImage(contentsOfFile: photoURL!.path) {
                VStack {
                    HStack {
                        Text("Ideia do dia \(photoModel.creationDate, formatter: self.dateFormatter)")
                            .bold()
                            .font(.system(size: 25))
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                    
                    Image(uiImage: uiImage)
                        .resizable()
                        .cornerRadius(25)
                        .aspectRatio(contentMode: .fit)
                        .rotationEffect(.degrees(90))
                        .frame(width: screenSize.width)
                    
                    Spacer()
                    
                    TextEditor(text: $photoModel.textComplete)
                        .padding()
                        .frame(maxHeight: 100)
                        .overlay {
                            Text(self.photoModel.textComplete.isEmpty ? "Digite sua nota." : "")
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    self.isFocused = true
                                }
                        }
                        .onAppear {
                            if !photoModel.textComplete.isEmpty {
                                DispatchQueue.main.async {
                                    // Atualizar a view para exibir o conteúdo existente da variável description
                                    self.photoModel.textComplete = photoModel.textComplete
                                }
                            }
                        }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    TextViewModel.setTextsFromIdea(idea: &photoModel)
                    IdeaSaver.changeSavedValue(type: PhotoModel.self, idea: self.photoModel)
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Voltar")
                    }
                }
            }
        }
        .navigationBarItems(trailing: Button(action: {
            IdeaSaver.clearOneIdea(type: PhotoModel.self, idea: photoModel)
            showAlert = true
        }) {
            Image(systemName: "trash")
                .foregroundColor(.red)
        })
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


//struct PhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoIdeaView()
//    }
//}

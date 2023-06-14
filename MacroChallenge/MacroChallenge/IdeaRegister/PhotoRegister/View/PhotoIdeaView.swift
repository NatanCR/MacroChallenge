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
                    
//                    Text("Ideia do dia \(photoModel.creationDate, formatter: self.dateFormatter)")
//                            .font(.custom("Sen-Bold", size: 23))
//                            .multilineTextAlignment(.leading)
                                        
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
                        .padding()
                        .overlay {
                            Text(self.photoModel.textComplete.isEmpty ? "Digite sua nota." : "")
                                .font(.custom("Sen-Regular", size: 17))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding(8)
                                .foregroundColor(Color("labelColor"))
                                .opacity(0.6)
                                .onTapGesture {
                                    self.isFocused = true
                                }
                        }
                    
//                        Spacer()
                    
                        .onAppear {
                            if !photoModel.textComplete.isEmpty {
                                DispatchQueue.main.async {
                                    // Atualizar a view para exibir o conteúdo existente da variável description
                                    self.photoModel.textComplete = photoModel.textComplete
                                }
                            }
                        }
                }
        .navigationTitle("Ideia do dia \(photoModel.creationDate, formatter: self.dateFormatter)")
        .navigationBarTitleDisplayMode(.large)
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
            ToolbarItem (placement: .navigationBarTrailing){
                Button{
                    IdeaSaver.clearOneIdea(type: PhotoModel.self, idea: photoModel)
                    showAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
//        .navigationBarItems(trailing: Button(action: {
//            IdeaSaver.clearOneIdea(type: PhotoModel.self, idea: photoModel)
//            showAlert = true
//        }) {
//            Image(systemName: "trash")
//                .foregroundColor(.red)
//        })
                
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
}


//struct PhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoIdeaView()
//    }
//}

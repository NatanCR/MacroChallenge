//
//  PhotoIdeaView.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 31/05/23.
//

import SwiftUI

struct PhotoIdeaView: View {
    @State var photoModel: PhotoModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    
    let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let uiImage = UIImage(data: photoModel.capturedImages) {
                    VStack {
                        HStack {
                            Text("Ideia do dia \(photoModel.creationDate, formatter: self.dateFormatter)")
                                .bold()
                                .font(.system(size: 25))
                            Spacer()
                        }
                        .padding()
                        
                        Image(uiImage: uiImage)
                            .resizable()
                            .cornerRadius(25)
                            .aspectRatio(contentMode: .fit)
                            .rotationEffect(.degrees(90))
                            .frame(width: geometry.size.width * 1.1)
                            .position(x: geometry.size.width/2.2, y: geometry.size.height/3.1)
                        
                        TextField("Notas", text: $photoModel.description, onEditingChanged: { isEditing in
                            if !isEditing {
                                    IdeaSaver.changeSavedValue(type: PhotoModel.self, idea: photoModel)
                            }
                        })
                            .padding()
                            .position(x:geometry.size.width/2, y: geometry.size.height/4)
                            .onAppear {
                                if !photoModel.description.isEmpty {
                                    DispatchQueue.main.async {
                                        // Atualizar a view para exibir o conteúdo existente da variável description
                                        self.photoModel.description = photoModel.description
                                    }
                                }
                            }
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

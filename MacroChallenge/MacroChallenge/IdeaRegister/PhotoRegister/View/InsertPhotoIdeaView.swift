//
//  InsertPhotoIdeaView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 10/07/23.
//

import SwiftUI

struct InsertPhotoIdeaView: View {
    @State var tookPicture: Bool = false
    @State var textComplete: String = ""
    @ObservedObject var ideasViewModel: IdeasViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.screenSize) var screenSize
    
    @State var photoModel: PhotoModel
    var photoURL: URL? = nil
    
    @FocusState var isFocused: Bool

    
    init(ideasViewModel: IdeasViewModel, photoModel: PhotoModel) {
        self._ideasViewModel = ObservedObject(initialValue: ideasViewModel)
        self._photoModel = State(initialValue: photoModel)
        self.photoURL = ContentDirectoryHelper.getDirectoryContent(contentPath: photoModel.capturedImages)
    }
    
    var body: some View {
        
        if tookPicture{

            if let uiImage = UIImage(contentsOfFile: photoURL!.path){
                    VStack{
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
                            .padding(9)

                    }
                    //TODO: fazer localizable desse título
                    .navigationTitle("Inserir imagem")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button{
                                print("salvando")
                            } label: {
                                Text("OK")
                            }
                        }
                    }
            } else {
                Text("não ta achando o caminho da imagem")
                    .navigationBarTitleDisplayMode(.inline)
                    .onAppear{
                        print(photoURL!.path)
                        print(photoModel)
                        print(ContentDirectoryHelper.getDirectoryContent(contentPath: photoModel.capturedImages))
                    }
            }

            } else {
                
                VStack{
                    Text("Nenhuma imagem adicionada")
                }
                .navigationTitle("Inserir imagem")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button{
                            print("abre camera")
                        } label: {
                            Image(systemName: "camera.fill")
                        }
                    }
                }
                .onAppear{
                    ideasViewModel.isShowingCamera = true
                    print(photoURL)
                    print(photoModel)
                }
                //abrir câmera
                .fullScreenCover(isPresented: $ideasViewModel.isShowingCamera) {
                    CameraRepresentable(tookPicture: $tookPicture,viewModel: ideasViewModel.cameraViewModel)
                }
            }
        }
    }

//struct InsertPhotoIdeaView_Previews: PreviewProvider {
//    static var previews: some View {
//        InsertPhotoIdeaView()
//    }
//}

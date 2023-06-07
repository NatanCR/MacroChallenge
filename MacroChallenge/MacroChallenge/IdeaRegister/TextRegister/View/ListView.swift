//
//  ListView.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 30/05/23.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var appState: AppState    
    @State private var loadedData = IdeaSaver.getAllSavedIdeas()
    @State private var sortedByDescendent: Bool = true
    @State private var byCreation: Bool = true
    @State private var disposedData: [any Idea] = []
    @State private var filterType: IdeaType = .text
    @State private var isFiltered: Bool = false
    
    //camera
    @StateObject private var viewModel = CameraViewModel()
    @State private var isShowingCamera = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func orderBy() {
        if byCreation {
            sortedByDescendent ? disposedData.sort(by: { $0.creationDate > $1.creationDate }) : disposedData.sort(by: { $0.creationDate < $1.creationDate })
        } else {
            sortedByDescendent ? disposedData.sort(by: { $0.modifiedDate > $1.modifiedDate }) : disposedData.sort(by: { $0.modifiedDate < $1.modifiedDate })
        }
    }
    
    func filterBy(_ type: IdeaType) {
        if (!isFiltered || (isFiltered && filterType != type)) {
            filterType = type
            isFiltered = true
            disposedData = loadedData.filter({ $0.ideiaType == type })
            return
        }
        
        self.disposedData = self.loadedData
        self.isFiltered = false
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Menu {
                        Menu("Ordenar por") {
                            Button("Data de adição (Padrão)") {
                                byCreation = true
                                orderBy()
                            }
                            Button("Data de edição") {
                                byCreation = false
                                orderBy()
                            }
                            Divider()
                            Button("Mais recente") {
                                sortedByDescendent = true
                                orderBy()
                            }
                            Button("Mais antigo") {
                                sortedByDescendent = false
                                orderBy()
                            }
                        }
                        Menu("Filtrar por") {
                            Button("Imagem") {
                                filterBy(.photo)
                            }
                            Button("Texto") {
                                filterBy(.text)
                            }
                            Button("Áudio") {
                                filterBy(.audio)
                            }
                        }
                    } label: {
                        Text(Image(systemName: "line.3.horizontal.decrease.circle"))
                    }

                }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(disposedData, id: \.id) { ideas in
                            NavigationLink {
                                switch ideas.ideiaType {
                                case .text:
                                    EditRegisterView(modelText: ideas as! ModelText)
                                case .audio:
                                    CheckAudioView(audioIdea: ideas as! AudioIdeia)
                                case .photo:
                                    PhotoIdeaView(photoModel: ideas as! PhotoModel)
                                }
                            } label: {
                                CellTemplate(idea: ideas)
                            }
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                let reloadedModel = IdeaSaver.getAllSavedIdeas()
                self.loadedData = reloadedModel
                self.disposedData = self.loadedData
            }
            //atualizando a view quando fechar a camera
            .onChange(of: isShowingCamera) { newValue in
                if !newValue {
                    loadedData = IdeaSaver.getAllSavedIdeas()
                    disposedData = loadedData
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        isShowingCamera = true
                    } label: {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $isShowingCamera) {
                        CameraRepresentable(viewModel: viewModel)
                    }
                    
                    Spacer()
                    
                    NavigationLink {
                        RecordAudioView()
                    } label: {
                        Image(systemName: "mic.fill")
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    NavigationLink {
                        TextRegisterView()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        //aciona o comportamento popToRootView
        .id(appState.rootViewId)
    }
}

//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListView()
//    }
//}

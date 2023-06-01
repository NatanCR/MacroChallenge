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
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func orderBy() {
        if byCreation {
            sortedByDescendent ? loadedData.sort(by: { $0.creationDate > $1.creationDate }) : loadedData.sort(by: { $0.creationDate < $1.creationDate })
        } else {
            sortedByDescendent ? loadedData.sort(by: { $0.modifiedDate > $1.modifiedDate }) : loadedData.sort(by: { $0.modifiedDate < $1.modifiedDate })
        }
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
                                
                            }
                            Button("Texto") {
                                
                            }
                            Button("Áudio") {
                                
                            }
                        }
                    } label: {
                        Text(Image(systemName: "line.3.horizontal.decrease.circle"))
                        
                    }

                }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(loadedData, id: \.id) { ideas in
                            NavigationLink {
                                if ideas.ideiaType == .text {
                                    EditRegisterView(modelText: ideas as! ModelText)
                                }
                            } label: {
                                CellTemplate(idea: ideas)
                            }
                        }
                    }
                }
                Spacer()
                NavigationLink {
                    TextRegisterView()
                } label: {
                    Text("Register Idea")
                }
            }
            .padding()
            .onAppear {
                let reloadedModel = IdeaSaver.getAllSavedIdeas()
                self.loadedData = reloadedModel
            }
        }
        //aciona o comportamento popToRootView
        .id(appState.rootViewId)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

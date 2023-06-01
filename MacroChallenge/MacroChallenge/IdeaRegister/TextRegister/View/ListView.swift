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
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(loadedData, id: \.id) { ideas in
                            NavigationLink {
                                if ideas.ideiaType == .text {
                                    //EditRegisterView(modelText: )
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

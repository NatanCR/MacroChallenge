//
//  HomeView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

//MARK: - HOME VIEW
struct HomeView: View {
    
    @StateObject var ideasViewModel: IdeasViewModel = IdeasViewModel()
    let audioManager: AudioManager = AudioManager()
    //quando for true altera para view de seleção de ideias
    @State var isAdding: Bool = false
    @FocusState private var searchInFocus: Bool
    
    //MARK: - HOME INIT
    //alteração da fonte dos títulos
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Sen-Bold", size: 30)!]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: "Sen-Bold", size: 17)!]
    }
    
    //MARK: - HOME BODY
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        SearchBarComponent(ideasViewModel: ideasViewModel)
                            .font(Font.custom("Sen-Regular", size: 17, relativeTo: .headline))
                            .focused($searchInFocus)
                        FilterComponent(ideasViewModel: ideasViewModel)
                            .padding(.trailing)
                    }
                    .padding(.vertical)
                    
                    SegmentedPickerComponent(ideasViewModel: ideasViewModel, audioManager: self.audioManager, isAdding: $isAdding)
                    
                    //navigation bar
                        .toolbar{
                            ToolbarItem(placement: .navigationBarTrailing){
                                
                                if isAdding == false{
                                    //leva para a InfoView
                                    NavigationLink {
                                        InfoView()
                                    } label: {
                                        Image(systemName: "info.circle.fill")
                                            .font(.system(size: 20))
                                    }
                                    
                                } else {
                                    //leva para a FolderView
                                    NavigationLink{
                                        FolderView(isAdding: $isAdding)
                                    } label: {
                                        Text("OK")
                                    }
                                }
                            }
                            
                            ToolbarItem(placement: .navigationBarLeading){
                                //volta para a tela padrão
                                if isAdding{
                                    Button("Cancel"){
                                        isAdding = false
                                    }
                                }
                            }
                            
                            ToolbarItem(placement: .bottomBar) {
                                ToolbarComponent(ideasViewModel: ideasViewModel)
                            }
                        }
                    
                }
                .navigationTitle(isAdding ? "New folder" : "ideas")
                .navigationBarTitleDisplayMode(isAdding ? .inline : .large)
                .background(Color("backgroundColor"))
                .ignoresSafeArea(.keyboard)
                .onAppear() {
                    self.appearInitialization()
                    //carrega o array de tags de novo para as ideias atualizarem quais tags elas tem
                    ideasViewModel.tagsFiltered = IdeaSaver.getAllSavedTags()
                    
                    ideasViewModel.favoriteIdeas = ideasViewModel.filteringFavoriteIdeas
                    ideasViewModel.filteredIdeas = ideasViewModel.filteringNotFavoriteIdeas
                }
                //atualizando a view quando fechar a camera
                .onChange(of: self.ideasViewModel.isShowingCamera) { newValue in
                    if !newValue {
                        if self.ideasViewModel.isFiltered {
                            self.ideasViewModel.reloadLoadedData()
                            self.ideasViewModel.orderBy(byCreation: self.ideasViewModel.isSortedByCreation, sortedByAscendent: self.ideasViewModel.isSortedByAscendent)
                        } else {
                            self.appearInitialization()
                        }
                    }
                }
                
                if searchInFocus != false{
                    Rectangle()
                        .fill(Color.pink)
                        .opacity(0.001)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture(perform: ideasViewModel.DismissKeyboard)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    //MARK: - HOME FUNC's
    // run in onAppear. Initializate the list of ideas only when opened the app
    private func appearInitialization() {
        self.ideasViewModel.resetDisposedData()
    }
}

//MARK: - GRID VIEW
// view em forma de grid
struct HomeGridView: View {
    @ObservedObject var ideasViewModel: IdeasViewModel
    let audioManager: AudioManager
    @Binding var isAdding: Bool
    @Environment(\.screenSize) var screenSize
    @State private var revealDetails: Bool = true
    
    //MARK: - GRID BODY
    var body: some View{
        ScrollView {
            VStack(alignment: .leading) {
                //mostra apenas se houver ideias favoritadas
                if ideasViewModel.favoriteIdeas.count != 0 {
                    //modo de expansão da grid de favoritos
                    DisclosureGroup(isExpanded: $revealDetails) {
                        GridViewComponent(ideasViewModel: ideasViewModel, audioManager: audioManager, isAdding: $isAdding, ideaType: $ideasViewModel.favoriteIdeas)
                            .padding(.bottom)
                    } label: {
                        Text("fav")
                            .font(.custom("Sen-Bold", size: 17, relativeTo: .headline))
                            .foregroundColor(Color("labelColor"))
                            .frame(width: screenSize.width * 0.22, height: screenSize.height * 0.015, alignment: .leading)
                            .padding(.bottom)
                    }
                }
                
                
                Text("all")
                    .font(.custom("Sen-Bold", size: 17, relativeTo: .headline))
                    .foregroundColor(Color("labelColor"))
                    .frame(width: screenSize.width * 0.22, height: screenSize.height * 0.015, alignment: .leading)
                    .padding(.bottom)
                GridViewComponent(ideasViewModel: ideasViewModel, audioManager: audioManager, isAdding: $isAdding, ideaType: $ideasViewModel.filteredIdeas)
            }.padding()
        }
    }
}

//MARK: - LIST VIEW
//view em forma de lista
struct HomeListView: View {
    @ObservedObject var ideasViewModel: IdeasViewModel
    @Binding var isAdding: Bool
    @State var selection = Set<UUID>()
    @Environment(\.screenSize) var screenSize
    
    //MARK: - LIST BODY
    var body: some View{
        VStack(alignment: .leading) {
            if #available(iOS 16.0, *){
                ListViewComponent(ideasViewModel: ideasViewModel, isAdding: $isAdding)
                    .environment(\.editMode, .constant(self.isAdding ? EditMode.active : EditMode.inactive))
                    .scrollContentBackground(.hidden)
                
            } else {
                //MARK: - OTHER iOS VERSION
                ListViewComponent(ideasViewModel: ideasViewModel, isAdding: $isAdding)
                    .environment(\.editMode, .constant(self.isAdding ? EditMode.active : EditMode.inactive))
            }
        }.padding(.horizontal)
    }
}

////MARK: - PREVIEW
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

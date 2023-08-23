//
//  HomeView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

//MARK: - HOME VIEW
struct HomeView: View {
    @Environment(\.screenSize) var screenSize
    @StateObject var ideasViewModel: IdeasViewModel = IdeasViewModel()
    let audioManager: AudioManager = AudioManager()
    //quando for true altera para view de seleção de ideias
    @State var isAdding: Bool = false
    @FocusState private var searchInFocus: Bool
    @State var sortedByAscendent: Bool = false
    @State var byCreation: Bool = false
    @AppStorage("appVersion") private var appVersion = "1.20.1" // versão antes da atualização "1.20.2" -> correção do bug das tags
    @State var selectedIdeas: [UUID] = []
    
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
                        SearchBarComponent(ideasViewModel: ideasViewModel, sortedByAscendent: $sortedByAscendent, byCreation: $byCreation)
                            .font(Font.custom("Sen-Regular", size: 17, relativeTo: .headline))
                            .focused($searchInFocus)
                        FilterComponent(ideasViewModel: ideasViewModel, sortedByAscendent: $sortedByAscendent, byCreation: $byCreation)
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
                    //pega a versão atual do app
                    let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                    //verifica se a versão atual é diferente da antiga setada acima na variavel
                    if appVersion != currentAppVersion {
                        //executa a função de correção
                        ideasViewModel.fixingTagColor()
                        //atribui a nova versão para a variável, assim nao entrerá mais nesse if
                        appVersion = currentAppVersion ?? ""
                    }
                    
                    self.appearInitialization()
                    //carrega o array de tags de novo para as ideias atualizarem quais tags elas tem
                    ideasViewModel.tagsFiltered = IdeaSaver.getAllSavedTags()
                    
                    ideasViewModel.weekIdeas = ideasViewModel.weekCorrentlyIdeas()
                    ideasViewModel.favoriteIdeas = ideasViewModel.filteringFavoriteIdeas()
                    ideasViewModel.filteredIdeas = ideasViewModel.notWeekIdeas()
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
    @State var selectedIdeas: [UUID] = []
    @State var newGroup: GroupModel = GroupModel(title: "", creationDate: Date(), modifiedDate: Date(), ideasIds: [])
    
    //MARK: - GRID BODY
    var body: some View{
        ScrollView {
            if ideasViewModel.disposedData.count == 0 {
                VStack(alignment: .center) {
                    Text("noIdeas")
                        .font(.custom("Sen-Regular", size: 17, relativeTo: .headline))
                        .foregroundColor(Color("labelColor"))
                }.frame(height: screenSize.height * 0.5)
                
            } else {
                VStack(alignment: .leading) {
                    //mostra apenas se houver ideias favoritadas
                    if ideasViewModel.favoriteIdeas.count != 0 {
                        //modo de expansão da grid de favoritos
                        DisclosureGroup(isExpanded: $ideasViewModel.revealSectionDetails) {
                            GridViewComponent(ideasViewModel: ideasViewModel, audioManager: audioManager, isAdding: $isAdding, ideaType: $ideasViewModel.favoriteIdeas, selectedIdeas: $selectedIdeas)
                                .padding(.bottom)
                        } label: {
                            Text("fav")
                                .font(.custom("Sen-Bold", size: 17, relativeTo: .headline))
                                .foregroundColor(Color("labelColor"))
                                .frame(width: screenSize.width * 0.22, height: screenSize.height * 0.015, alignment: .leading)
                                .padding(.bottom)
                        }
                    }
                    
                    if ideasViewModel.weekIdeas.count != 0 {
                        Text("week")
                            .font(.custom("Sen-Bold", size: 17, relativeTo: .headline))
                            .foregroundColor(Color("labelColor"))
                        GridViewComponent(ideasViewModel: ideasViewModel, audioManager: audioManager, isAdding: $isAdding, ideaType: $ideasViewModel.weekIdeas, selectedIdeas: $selectedIdeas)
                            .padding(.bottom)
                    }
                    
                    if ideasViewModel.filteredIdeas.count != 0 {
                        Text("prev")
                            .font(.custom("Sen-Bold", size: 17, relativeTo: .headline))
                            .foregroundColor(Color("labelColor"))
                            .frame(width: screenSize.width * 0.22, height: screenSize.height * 0.015, alignment: .leading)
                            .padding(.bottom)
                        GridViewComponent(ideasViewModel: ideasViewModel, audioManager: audioManager, isAdding: $isAdding, ideaType: $ideasViewModel.filteredIdeas, selectedIdeas: $selectedIdeas)
                    }
                }.padding()
            }
        }
        .onAppear {
            //faz a verificação para expandir a seção de favoritos caso haja ideia favoritada
            if self.ideasViewModel.favoriteIdeas.count != 0 {
                self.ideasViewModel.revealSectionDetails = true
            } else {
                self.ideasViewModel.revealSectionDetails = false
            }
        }
        .onChange(of: isAdding) { newValue in
            if newValue {
                selectedIdeas = []
                print("limpei")
            } else {
                newGroup = GroupModel(title: "Sem título", creationDate: Date(), modifiedDate: Date(), ideasIds: selectedIdeas)
                print(newGroup)
                if newGroup.ideasIds.count > 0 {
                    IdeaSaver.saveGroup(group: newGroup)
                    ideasViewModel.groups = IdeaSaver.getAllSavedGroups()
                }
            }
        }
    }
}

//MARK: - LIST VIEW
//view em forma de lista
struct HomeListView: View {
    @Environment(\.screenSize) var screenSize
    @ObservedObject var ideasViewModel: IdeasViewModel
    @Binding var isAdding: Bool
    @State var selection = Set<UUID>()
    
    //MARK: - LIST BODY
    var body: some View{
        VStack(alignment: .leading) {
            if ideasViewModel.disposedData.count == 0 {
                VStack(alignment: .center) {
                    Text("noIdeas")
                        .font(.custom("Sen-Regular", size: 17, relativeTo: .headline))
                        .foregroundColor(Color("labelColor"))
                }.frame(height: screenSize.height * 0.5)
                
            } else {
                if #available(iOS 16.0, *){
                    ListViewComponent(ideasViewModel: ideasViewModel, isAdding: $isAdding)
                        .environment(\.editMode, .constant(self.isAdding ? EditMode.active : EditMode.inactive))
                        .scrollContentBackground(.hidden)
                    
                } else {
                    //MARK: - OTHER iOS VERSION
                    ListViewComponent(ideasViewModel: ideasViewModel, isAdding: $isAdding)
                        .environment(\.editMode, .constant(self.isAdding ? EditMode.active : EditMode.inactive))
                }
            }
            Spacer()
        }.padding(.horizontal)
    }
}

////MARK: - PREVIEW
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

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
                    ideasViewModel.tagsLoadedData = IdeaSaver.getAllSavedTags()
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
    @State var selectedIdeas: [any Idea] = []
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    //MARK: - GRID BODY
    var body: some View{
        
        ScrollView{
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(self.$ideasViewModel.filteredIdeas, id: \.id) { $ideas in
                    if isAdding == false {
                        NavigationLink {
                            switch ideas.ideiaType {
                            case .text:
                                EditRegisterView(modelText: ideas as! ModelText, viewModel: ideasViewModel)
                            case .audio:
                                CheckAudioView(audioIdea: ideas as! AudioIdea, viewModel: ideasViewModel)
                            case .photo:
                                PhotoIdeaView(photoModel: ideas as! PhotoModel, viewModel: ideasViewModel)
                            }
                        } label: {
                            switch ideas.ideiaType {
                            case .text:
                                TextPreviewComponent(text: ideas.textComplete, title: ideas.title, idea: $ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding, selectedIdeas: $selectedIdeas)
                            case .audio:
                                AudioPreviewComponent(title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, audioManager: self.audioManager, selectedIdeas: $selectedIdeas, isAdding: $isAdding)
                            case .photo:
                                let photoIdea = ideas as! PhotoModel
                                ImagePreviewComponent(image: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage(), title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding, selectedIdeas: $selectedIdeas)
                            }
                        }
                    } else {
                        switch ideas.ideiaType {
                        case .text:
                            TextPreviewComponent(text: ideas.textComplete, title: ideas.title, idea: $ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding, selectedIdeas: $selectedIdeas)
                        case .audio:
                            AudioPreviewComponent(title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, audioManager: self.audioManager, selectedIdeas: $selectedIdeas, isAdding: $isAdding)
                        case .photo:
                            let photoIdea = ideas as! PhotoModel
                            ImagePreviewComponent(image: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage(), title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding, selectedIdeas: $selectedIdeas)
                        }
                    }
                }
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
    
    //MARK: - LIST BODY
    var body: some View{
        
        if #available(iOS 16.0, *){
            List {
                ForEach(self.$ideasViewModel.filteredIdeas, id: \.id) { $ideas in
                    NavigationLink {
                        switch ideas.ideiaType {
                        case .text:
                            EditRegisterView(modelText: ideas as! ModelText, viewModel: ideasViewModel)
                        case .audio:
                            CheckAudioView(audioIdea: ideas as! AudioIdea, viewModel: ideasViewModel)
                        case .photo:
                            PhotoIdeaView(photoModel: ideas as! PhotoModel, viewModel: ideasViewModel)
                        }
                    } label: {
                        if let photoIdea = ideas as? PhotoModel {
                            ListRowComponent(ideasViewModel: self.ideasViewModel, idea: $ideas, title: ideas.title, typeIdea: ideas.ideiaType, imageIdea: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage())
                        }
                        else {
                            ListRowComponent(ideasViewModel: self.ideasViewModel, idea: $ideas, title: ideas.title, typeIdea: ideas.ideiaType, imageIdea: UIImage())
                        }
                    }
                }
                .listRowBackground(Color("backgroundItem"))
            }
            .environment(\.editMode, .constant(self.isAdding ? EditMode.active : EditMode.inactive))
            .scrollContentBackground(.hidden)
            
        } else {
            List {
                ForEach(self.$ideasViewModel.filteredIdeas, id: \.id) { $ideas in
                    NavigationLink {
                        switch ideas.ideiaType {
                        case .text:
                            EditRegisterView(modelText: ideas as! ModelText, viewModel: ideasViewModel)
                        case .audio:
                            CheckAudioView(audioIdea: ideas as! AudioIdea, viewModel: ideasViewModel)
                        case .photo:
                            PhotoIdeaView(photoModel: ideas as! PhotoModel, viewModel: ideasViewModel)
                        }
                    } label: {
                        if let photoIdea = ideas as? PhotoModel {
                            ListRowComponent(ideasViewModel: self.ideasViewModel, idea: $ideas, title: ideas.title, typeIdea: ideas.ideiaType, imageIdea: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage())
                        }
                        else {
                            ListRowComponent(ideasViewModel: self.ideasViewModel, idea: $ideas, title: ideas.title, typeIdea: ideas.ideiaType, imageIdea: UIImage())
                        }
                    }
                    .listRowBackground(Color("backgroundItem"))
                }
                .environment(\.editMode, .constant(self.isAdding ? EditMode.active : EditMode.inactive))
            }
            
        }
    }
}

////MARK: - PREVIEW
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

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
    @State var selectedIdeas: [UUID] = []
    @State var isNewIdea: Bool = true
    
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
                    
                    SegmentedPickerComponent(ideasViewModel: ideasViewModel, audioManager: self.audioManager, isAdding: $isAdding, selectedIdeas: $selectedIdeas)
                    
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
                                        let newGroup = GroupModel(title: "", creationDate: Date(), modifiedDate: Date(), ideasIds: selectedIdeas)
                                        GroupView(ideasViewModel: ideasViewModel, isAdding: $isAdding, group: newGroup, isNewIdea: $isNewIdea)
                                    } label: {
                                        Text("OK")
                                    }
                                    .disabled(selectedIdeas.count <= 0)
                                }
                            }
                            
                            ToolbarItem(placement: .navigationBarLeading){
                                //volta para a tela padrão
                                if isAdding{
                                    Button("cancel"){
                                        isAdding = false
                                    }
                                }
                            }
                            
                            ToolbarItem(placement: .bottomBar) {
                                ToolbarComponent(ideasViewModel: ideasViewModel)
                            }
                        }
                    
                }
                .navigationTitle(isAdding ? "newFolder" : "ideas")
                .navigationBarTitleDisplayMode(isAdding ? .inline : .large)
                .background(Color("backgroundColor"))
                .ignoresSafeArea(.keyboard)
                .onAppear() {
                    self.appearInitialization()
                    //carrega o array de tags de novo para as ideias atualizarem quais tags elas tem
                    ideasViewModel.tagsLoadedData = IdeaSaver.getAllSavedTags()
                    dump(ideasViewModel.groups)
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
        .onChange(of: isAdding) { newValue in
            if newValue {
                selectedIdeas = []
            } 
        }
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
    @Binding var selectedIdeas: [UUID]
    @State var isNewIdea: Bool = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    //MARK: - GRID BODY
    var body: some View{
        
        ScrollView{
            LazyVGrid(columns: columns, spacing: 20) {
                if isAdding == false {
                    ForEach(ideasViewModel.groups, id: \.id) { group in
                        NavigationLink{
                            GroupView(ideasViewModel: ideasViewModel, isAdding: $isAdding, group: group, isNewIdea: $isNewIdea)
                        } label: {
                            GroupPreviewComponent(group: group, ideasViewModel: ideasViewModel)
                        }
                    }
                }
                ForEach(self.$ideasViewModel.filteredIdeas, id: \.id) { $ideas in
                    if ideas.isGrouped == false {
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
                                    TextPreviewComponent(text: ideas.textComplete, title: ideas.title, idea: $ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding, selectedIdeas: $selectedIdeas, isNewIdea: $isNewIdea)
                                case .audio:
                                    AudioPreviewComponent(title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, audioManager: self.audioManager, isAdding: $isAdding, selectedIdeas: $selectedIdeas, isNewIdea: $isNewIdea)
                                case .photo:
                                    let photoIdea = ideas as! PhotoModel
                                    ImagePreviewComponent(image: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage(), title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding, selectedIdeas: $selectedIdeas, isNewIdea: $isNewIdea)
                                }
                            }
                        } else {
                            switch ideas.ideiaType {
                            case .text:
                                TextPreviewComponent(text: ideas.textComplete, title: ideas.title, idea: $ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding, selectedIdeas: $selectedIdeas, isNewIdea: $isNewIdea)
                            case .audio:
                                AudioPreviewComponent(title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, audioManager: self.audioManager, isAdding: $isAdding, selectedIdeas: $selectedIdeas, isNewIdea: $isNewIdea)
                            case .photo:
                                let photoIdea = ideas as! PhotoModel
                                ImagePreviewComponent(image: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage(), title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, isAdding: $isAdding, selectedIdeas: $selectedIdeas, isNewIdea: $isNewIdea)
                            }
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
    @Binding var selectedIdeas: [UUID]
    @State var isNewIdea: Bool = false
    
    //MARK: - LIST BODY
    var body: some View{
        
        if #available(iOS 16.0, *){
            List (selection: $selection){
                if isAdding == false {
                    ForEach(ideasViewModel.groups, id: \.id) { group in
                        NavigationLink{
                            GroupView(ideasViewModel: ideasViewModel, isAdding: $isAdding, group: group, isNewIdea: $isNewIdea)
                        } label: {
//                            GroupPreviewComponent(group: group, ideasViewModel: ideasViewModel)
                            ListGroupComponent(group: group, ideasViewModel: ideasViewModel)
                        }
                    }
                    .listRowBackground(Color("backgroundItem"))
                    .environment(\.editMode, .constant(self.isAdding ? EditMode.active : EditMode.inactive))

                }
                ForEach(self.$ideasViewModel.filteredIdeas, id: \.id) { $ideas in
                    if ideas.isGrouped == false || ideas.isGrouped && isAdding {
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
                        .onChange(of: selection) { newValue in
                            selectedIdeas = []
                            ideas.isGrouped = false
                            for id in selection {
                                ideas.isGrouped = true
                                saveIdea(idea: ideas)
                                selectedIdeas.append(id)
                            }
                        }
                    }
                }
                .listRowBackground(Color("backgroundItem"))
            }
            .environment(\.editMode, .constant(self.isAdding ? EditMode.active : EditMode.inactive))
            .scrollContentBackground(.hidden)
            
        } else {
            List (selection: $selection){
                if isAdding == false {
                    ForEach(ideasViewModel.groups, id: \.id) { group in
                        NavigationLink{
                            GroupView(ideasViewModel: ideasViewModel, isAdding: $isAdding, group: group, isNewIdea: $isNewIdea)
                        } label: {
                            //                        GroupPreviewComponent(group: group, ideasViewModel: ideasViewModel)
                            ListGroupComponent(group: group, ideasViewModel: ideasViewModel)
                        }
                        .listRowBackground(Color("backgroundItem"))
                    }
                }
                ForEach(self.$ideasViewModel.filteredIdeas, id: \.id) { $ideas in
                    if ideas.isGrouped == false || ideas.isGrouped && isAdding {
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
                        .onChange(of: selection) { newValue in
                            selectedIdeas = []
                            ideas.isGrouped = false
                            for id in selection {
                                ideas.isGrouped = true
                                saveIdea(idea: ideas)
                                selectedIdeas.append(id)
                            }
                        }
                        .listRowBackground(Color("backgroundItem"))
                    }
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

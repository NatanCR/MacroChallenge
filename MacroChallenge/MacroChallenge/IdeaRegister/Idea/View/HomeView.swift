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

    //MARK: - HOME INIT
    //alteração da fonte dos títulos
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Sen-Bold", size: 30)!]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: "Sen-Bold", size: 17)!]
    }
    
    //MARK: - HOME BODY
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    SearchBarComponent(ideasViewModel: ideasViewModel)
                        .font(Font.custom("Sen-Regular", size: 17, relativeTo: .headline))
                    FilterComponent(ideasViewModel: ideasViewModel)
                        .padding(.trailing)
                }
                
                SegmentedPickerComponent(ideasViewModel: ideasViewModel, audioManager: self.audioManager)
  
                //navigation bar
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                      
                        NavigationLink {
                            InfoView()
                        } label: {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 20))
                        }
                    }
                }
                
                //toolbar para adicionar ideias
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        ToolbarComponent(ideasViewModel: ideasViewModel)
                    }
                }
                
            }.navigationTitle("ideas")
             .background(Color("backgroundColor"))
             .onAppear() {
                 self.appearInitialization()
             }
            //atualizando a view quando fechar a camera
             .onChange(of: self.ideasViewModel.isShowingCamera) { newValue in
                if !newValue {
                    self.ideasViewModel.loadedData = IdeaSaver.getAllSavedIdeas()
                    self.ideasViewModel.filteredIdeas = ideasViewModel.loadedData
                }
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
    
    //MARK: - HOME FUNC's
    // run in onAppear. Initializate the list of ideas only when opened the app
    private func appearInitialization() {
        self.ideasViewModel.reloadLoadedData()
        self.ideasViewModel.filteredIdeas = ideasViewModel.loadedData
        self.ideasViewModel.orderBy(byCreation: self.ideasViewModel.isSortedByCreation, sortedByAscendent: self.ideasViewModel.isSortedByAscendent)
    }
}

//MARK: - GRID VIEW
// view em forma de grid
struct HomeGridView: View {
    @ObservedObject var ideasViewModel: IdeasViewModel
    let audioManager: AudioManager
    
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
                    NavigationLink {
                        switch ideas.ideiaType {
                        case .text:
                            EditRegisterView(modelText: ideas as! ModelText, viewModel: ideasViewModel)
                        case .audio:
                            CheckAudioView(audioIdea: ideas as! AudioIdeia, viewModel: ideasViewModel)
                        case .photo:
                            PhotoIdeaView(photoModel: ideas as! PhotoModel)
                        }
                    } label: {
                        switch ideas.ideiaType {
                        case .text:
                            TextPreviewComponent(text: ideas.textComplete, title: ideas.title, idea: $ideas, ideasViewModel: self.ideasViewModel)
                        case .audio:
                            AudioPreviewComponent(title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel, audioManager: self.audioManager)
                        case .photo:
                            let photoIdea = ideas as! PhotoModel
                            ImagePreviewComponent(image: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage(), title: ideas.title, idea: ideas, ideasViewModel: self.ideasViewModel)
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
                            CheckAudioView(audioIdea: ideas as! AudioIdeia, viewModel: ideasViewModel)
                        case .photo:
                            PhotoIdeaView(photoModel: ideas as! PhotoModel)
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
            .scrollContentBackground(.hidden)

        } else {
            List {
                ForEach(self.$ideasViewModel.filteredIdeas, id: \.id) { $ideas in
                    NavigationLink {
                        switch ideas.ideiaType {
                        case .text:
                            EditRegisterView(modelText: ideas as! ModelText, viewModel: ideasViewModel)
                        case .audio:
                            CheckAudioView(audioIdea: ideas as! AudioIdeia, viewModel: ideasViewModel)
                        case .photo:
                            PhotoIdeaView(photoModel: ideas as! PhotoModel)
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
        }
        
    }
}

//MARK: - PREVIEW
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

//
//  HomeView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var ideasViewModel: IdeasViewModel = IdeasViewModel()
    let audioManager: AudioManager = AudioManager()

    //alteração da fonte dos títulos
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Sen-Bold", size: 30)!]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: "Sen-Bold", size: 17)!]
        
    }
    
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
                
            }.navigationTitle("Ideas")
             .background(Color("backgroundColor"))
             .onAppear {
                 let reloadedModel = IdeaSaver.getAllSavedIdeas()
                 self.ideasViewModel.loadedData = reloadedModel
                 self.ideasViewModel.filteredIdeas = ideasViewModel.loadedData
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
}

// view em forma de grid
struct HomeGridView: View {
    @ObservedObject var ideasViewModel: IdeasViewModel
    let audioManager: AudioManager
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View{
        
        ScrollView{
            //TODO: fazer for each dos arquivos salvos
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(self.$ideasViewModel.filteredIdeas, id: \.id) { $ideas in
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
                        switch ideas.ideiaType {
                        case .text:
                            TextPreviewComponent(text: ideas.textComplete, title: ideas.title, editDate: ideas.modifiedDate, idea: $ideas)
                        case .audio:
                            AudioPreviewComponent(title: ideas.title, editDate: ideas.modifiedDate, idea: ideas, audioManager: self.audioManager)
                        case .photo:
                            let photoIdea = ideas as! PhotoModel
                            ImagePreviewComponent(image: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage(), title: ideas.title, editDate: ideas.modifiedDate, idea: ideas)
                        }
                    }.onAppear {
                        //dump(ideas)
                    }
                }
            }.padding()
        }
    }
}

//view em forma de lista
struct HomeListView: View {
    @ObservedObject var ideasViewModel: IdeasViewModel
    
    var body: some View{
        
        if #available(iOS 16.0, *){
            List {
                ForEach(self.ideasViewModel.filteredIdeas, id: \.id) { ideas in
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
                        if let photoIdea = ideas as? PhotoModel {
                            ListRowComponent(title: ideas.title, infoDate: ideas.modifiedDate, typeIdea: ideas.ideiaType, imageIdea: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage())
                        }
                        else {
                            ListRowComponent(title: ideas.title, infoDate: ideas.modifiedDate, typeIdea: ideas.ideiaType, imageIdea: UIImage())
                        }
                    }
                }
                .listRowBackground(Color("backgroundItem"))
            }
            .scrollContentBackground(.hidden)
        } else {
            List {
                ForEach(self.ideasViewModel.filteredIdeas, id: \.id) { ideas in
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
                        if let photoIdea = ideas as? PhotoModel {
                            ListRowComponent(title: ideas.title, infoDate: ideas.modifiedDate, typeIdea: ideas.ideiaType, imageIdea: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage())
                        }
                        else {
                            ListRowComponent(title: ideas.title, infoDate: ideas.modifiedDate, typeIdea: ideas.ideiaType, imageIdea: UIImage())
                        }
                    }
                }
                .listRowBackground(Color("backgroundItem"))
            }
        }
    }
}
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }

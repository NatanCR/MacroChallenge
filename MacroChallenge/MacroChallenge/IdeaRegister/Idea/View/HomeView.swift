//
//  HomeView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct HomeView: View {
    @State static var loadedData = IdeaSaver.getAllSavedIdeas()
    @State static var sortedByDescendent: Bool = true
    @State static var byCreation: Bool = true
    @State static var disposedData: [any Idea] = []
    @State static var filterType: IdeaType = .text
    @State static var isFiltered: Bool = false
    @State static var searchText: String = ""
    @State static var isList: Bool = false
    
    //camera
    @StateObject static var viewModel = CameraViewModel()
    @State static var isShowingCamera = false
    
    //alteração da fonte dos títulos
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Sen-Bold", size: 30)!]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: "Sen-Bold", size: 17)!]
    }
    
    
    var body: some View {
        
        NavigationView {
            VStack{
                SearchBarComponent()
                    .font(Font.custom("Sen-Regular", size: 17))
                    .padding(.trailing)
                
                SegmentedPickerComponent()
  
                //navigation bar
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                      
                        NavigationLink {
                            InfoView(infoText: "Porem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent auctor purus luctus enim egestas, ac scelerisque ante pulvinar.")
                        } label: {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 20))
                        }
                        
                    }
                }
                
                //toolbar para adicionar ideias
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        ToolbarComponent()
                    }
                }
                
            }.navigationTitle("Ideas")
             .background(Color("backgroundColor"))
       
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
}

// view em forma de grid
struct HomeGridView: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View{
        
        ScrollView{
            //TODO: fazer for each dos arquivos salvos
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(SearchBarComponent.filteredIdeas, id: \.id) { ideas in
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
                            TextPreviewComponent(text: ideas.textComplete, title: ideas.title, description: ideas.description)
                        case .audio:
                            AudioPreviewComponent(title: ideas.title, description: ideas.description)
                        case .photo:
                            ImagePreviewComponent(image: UIImage(systemName: "rectangle.fill") ?? UIImage(), title: ideas.title, description: ideas.description)
                        }
                    }
                }
//                ForEach((1...9), id: \.self) { i in
//                    // teste para texto
//                    if i < 4 {
//                            TextPreviewComponent(text: "oioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioi")
//                    }
//
//                    // teste para audio
//                    else if i >= 4 && i < 7 {
//                        AudioPreviewComponent()
//                    }
//
//                    // teste para foto
//                    else {
//                        ImagePreviewComponent(image: UIImage(systemName: "rectangle.fill") ?? UIImage())
//                    }
//                }
            }.padding()
            
        }
        .onAppear {
            let reloadedModel = IdeaSaver.getAllSavedIdeas()
            HomeView.loadedData = reloadedModel
            HomeView.disposedData = HomeView.loadedData
            // orderBy
        }
        //atualizando a view quando fechar a camera
        .onChange(of: HomeView.isShowingCamera) { newValue in
            if !newValue {
                HomeView.loadedData = IdeaSaver.getAllSavedIdeas()
                HomeView.disposedData = HomeView.loadedData
            }
        }
    }
}

//view em forma de lista
struct HomeListView: View {
    var body: some View{
        List {
            ForEach(SearchBarComponent.filteredIdeas, id: \.id) { ideas in
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
                    ListRowComponent(title: ideas.title, infoDate: ideas.modifiedDate, typeIdea: ideas.ideiaType, imageIdea: UIImage(systemName: "rectangle.fill") ?? UIImage())
                }

            }
//            ForEach((1...9), id: \.self) { i in
//
//                // teste para texto
//                if i < 4 {
//                    ListRowComponent(title: "texto", info: "data de adição ou edição", image: UIImage())
//                }
//
//                // teste para audio
//                else if i >= 4 && i < 7 {
//                    HStack{
//                        ListRowComponent(title: "audio", info: "data de adição ou edição", image: UIImage())
//                        Image(systemName: "waveform.and.mic")
//                            .font(.system(size: 25))
//                            .foregroundColor(Color("labelColor"))
//                            .padding(.trailing)
//                    }
//
//                }
//
//                // teste para foto
//                else {
//                    ListRowComponent(title: "foto", info: "data de adição ou edição", image: UIImage(systemName: "photo.fill") ?? UIImage())
//
//                }
//
//            }
            .listRowBackground(Color("backgroundItem"))
        }
        .onAppear {
            let reloadedModel = IdeaSaver.getAllSavedIdeas()
            HomeView.loadedData = reloadedModel
            HomeView.disposedData = HomeView.loadedData
            // orderBy
        }
        //atualizando a view quando fechar a camera
        .onChange(of: HomeView.isShowingCamera) { newValue in
            if !newValue {
                HomeView.loadedData = IdeaSaver.getAllSavedIdeas()
                HomeView.disposedData = HomeView.loadedData
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

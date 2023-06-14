//
//  HomeView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct HomeView: View {
    @State var loadedData = IdeaSaver.getAllSavedIdeas()
    @State var sortedByDescendent: Bool = true
    @State var byCreation: Bool = true
    @State var disposedData: [any Idea] = IdeaSaver.getAllSavedIdeas()
    @State var filteredIdeas: [any Idea] = IdeaSaver.getAllSavedIdeas()
    @State var filterType: IdeaType = .text
    @State var isFiltered: Bool = false
    @State var isList: Bool = false
    
    //camera
    @StateObject var viewModel = CameraViewModel()
    @State var isShowingCamera = false
    
    //alteração da fonte dos títulos
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Sen-Bold", size: 30)!]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: "Sen-Bold", size: 17)!]
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                HStack {
                    SearchBarComponent(disposedData: $disposedData, receiveFilteredIdeas: $filteredIdeas)
                        .font(Font.custom("Sen-Regular", size: 17))
                    FilterComponent(sortedByDescendent: sortedByDescendent, byCreation: byCreation, disposedData: $disposedData, filteredData: $filteredIdeas, loadedData: loadedData, isFiltered: isFiltered, filterType: filterType)
                        .padding(.trailing)
                }
                
                SegmentedPickerComponent(loadedData: loadedData, filteredIdeas: $filteredIdeas, filtertType: filterType)
  
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
                        ToolbarComponent(isShowingCamera: $isShowingCamera)
                    }
                }
                
            }.navigationTitle("Ideas")
             .background(Color("backgroundColor"))
             .onAppear {
                 let reloadedModel = IdeaSaver.getAllSavedIdeas()
                 self.loadedData = reloadedModel
                 self.filteredIdeas = loadedData
             }
            //atualizando a view quando fechar a camera
            .onChange(of: self.isShowingCamera) { newValue in
                if !newValue {
                    self.loadedData = IdeaSaver.getAllSavedIdeas()
                    self.filteredIdeas = loadedData
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
}

// view em forma de grid
struct HomeGridView: View {
    @State var loadedData: [any Idea]
    @Binding var filteredIdeas: [any Idea]
    @State var filterType: IdeaType
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View{
        
        ScrollView{
            //TODO: fazer for each dos arquivos salvos
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(self.filteredIdeas, id: \.id) { ideas in
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
                            let photoIdea = ideas as! PhotoModel
                            ImagePreviewComponent(image: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage(), title: ideas.title, description: ideas.description)
                        }
                    }
                }
            }.padding()
        }
    }
}

//view em forma de lista
struct HomeListView: View {
    @State var loadedData: [any Idea]
    @Binding var filteredIdeas: [any Idea]
    @State var filterType: IdeaType
    
    var body: some View{
        
        if #available(iOS 16.0, *){
            List {
                ForEach((1...9), id: \.self) { i in
                    
                    // teste para texto
                    if i < 4 {
                        ListRowComponent(title: "Texto grande pra testar se ta okdafklj;aldskjf;lajsd;lfkjasdl;kjfalkdsjaflsdjfalkjsflkajdslfjasd;ljfld", info: "data de adição ou edição", image: UIImage())
                    }
                    
                    // teste para audio
                    else if i >= 4 && i < 7 {
                        HStack{
                            ListRowComponent(title: "audio", info: "data de adição ou edição", image: UIImage(systemName: "waveform.and.mic") ?? UIImage())
                        }
                        
                    }
                    
                    // teste para foto
                    else {
                        ListRowComponent(title: "foto", info: "data de adição ou edição", image: UIImage(systemName: "photo.fill") ?? UIImage())
                        
                    }
                    
                }
                .listRowBackground(Color("backgroundItem"))
            }
            .scrollContentBackground(.hidden)
        } else {
            List {
                ForEach((1...9), id: \.self) { i in
                    
                    // teste para texto
                    if i < 4 {
                        ListRowComponent(title: "texto", info: "data de adição ou edição", image: UIImage(systemName: "textformat.alt") ?? UIImage())
                    }
                    
                    // teste para audio
                    else if i >= 4 && i < 7 {
                        HStack{
                            ListRowComponent(title: "audio", info: "data de adição ou edição", image: UIImage(systemName: "waveform.and.mic") ?? UIImage())
                        }
                        
                    }
                    
                    // teste para foto
                    else {
                        ListRowComponent(title: "foto", info: "data de adição ou edição", image: UIImage(systemName: "photo.fill") ?? UIImage())
                        
                    }
                    
                }
                .listRowBackground(Color("backgroundItem"))
            }
        List {
            ForEach(self.filteredIdeas, id: \.id) { ideas in
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
                    let photoIdea = ideas as! PhotoModel
                    ListRowComponent(title: ideas.title, infoDate: ideas.modifiedDate, typeIdea: ideas.ideiaType, imageIdea: UIImage(contentsOfFile: ContentDirectoryHelper.getDirectoryContent(contentPath: photoIdea.capturedImages).path) ?? UIImage())
                }
            }
            .listRowBackground(Color("backgroundItem"))
        }
       
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

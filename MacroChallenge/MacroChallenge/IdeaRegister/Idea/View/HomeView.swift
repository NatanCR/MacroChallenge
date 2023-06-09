//
//  HomeView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct HomeView: View {
    
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
                      
                        NavigationLink{
                            InfoView(infoTitle: "", infoText: "")
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
                
        }
        .background(Color("backgroundColor"))
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
                ForEach((1...9), id: \.self) { i in
                    // teste para texto
                    if i < 4 {
                            TextPreviewComponent(text: "oioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioioi")
                    }
                    
                    // teste para audio
                    else if i >= 4 && i < 7 {
                        AudioPreviewComponent()
                    }
                    
                    // teste para foto
                    else {
                        ImagePreviewComponent(image: UIImage(systemName: "rectangle.fill") ?? UIImage())
                    }
                }
            }.padding()
            
        }
    }
}

//view em forma de lista
struct HomeListView: View {
    var body: some View{
        List {
            ForEach((1...9), id: \.self) { i in
                
                // teste para texto
                if i < 4 {
                    ListRowComponent(title: "texto", info: "data de adição ou edição", image: UIImage())
                }
                
                // teste para audio
                else if i >= 4 && i < 7 {
                    HStack{
                        ListRowComponent(title: "audio", info: "data de adição ou edição", image: UIImage())
                        Image(systemName: "waveform.and.mic")
                            .font(.system(size: 25))
                            .foregroundColor(Color("labelColor"))
                            .padding(.trailing)
                    }

                }
                
                // teste para foto
                else {
                    ListRowComponent(title: "foto", info: "data de adição ou edição", image: UIImage(systemName: "photo.fill") ?? UIImage())
                    
                }
                
            }
        }
        .listRowBackground(hidden())
    
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

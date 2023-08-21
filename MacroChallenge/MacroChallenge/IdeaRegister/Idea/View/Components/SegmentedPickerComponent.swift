//
//  SegmentedPickerComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 07/06/23.
//

import SwiftUI
import UIKit

struct SegmentedPickerComponent: View {
    @Environment(\.screenSize) var screenSize
    @State var index = 1
    @ObservedObject var ideasViewModel: IdeasViewModel
    @Binding var isAdding: Bool
    
    let audioManager: AudioManager
    
    //altera as cores do segmented picker
    init(ideasViewModel: IdeasViewModel, audioManager: AudioManager, isAdding: Binding<Bool>){
        self.ideasViewModel = ideasViewModel
        self.audioManager = audioManager
        self._isAdding = isAdding
        
        UISegmentedControl.appearance().backgroundColor = UIColor(Color("AccentColor")).withAlphaComponent(0.19)
        UISegmentedControl.appearance().setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("labelColor"))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color("backgroundColor"))], for: .selected)
    }
    
    var body: some View {
        VStack{
            
            if isAdding == false{
                HStack{
                    //segmented picker
                    Picker("segmented picker", selection: $index){
                        Image(systemName: "list.bullet").tag(0)
                        Image(systemName: "square.grid.2x2").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 100)
                    .padding()
                    
                    Spacer()
                    NewFolderComponent(isAdding: $isAdding)
                }
            }else{
                //apresenta texto para adicionar na pasta
                Text("Select your ideas")
                    .font(.custom("Sen-Regular", size: 20))
                    .frame(width: screenSize.width * 0.9, alignment: .leading)
            }
            
                //define o tipo de visualização
            if index == 0{
                HomeListView(ideasViewModel: ideasViewModel, isAdding: $isAdding)
            } else{
                HomeGridView(ideasViewModel: ideasViewModel, audioManager: self.audioManager, isAdding: $isAdding)
            }
        }
    }
}

//struct SegmentedPickerComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        SegmentedPickerComponent(loadedData: [Idea], disposedData: [any Idea], filtertType: IdeaType.text, isShowingCamera: false)
//    }
//}

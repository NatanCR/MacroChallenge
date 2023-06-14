//
//  SegmentedPickerComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 07/06/23.
//

import SwiftUI
import UIKit

struct SegmentedPickerComponent: View {
    @State var loadedData: [any Idea]
    @Binding var filteredIdeas: [any Idea]
    @State var filterType: IdeaType
    @State var isShowingCamera: Bool
    @State var index = 1
    
    //altera as cores do segmented picker
    init(loadedData: [any Idea], filteredIdeas: Binding<[any Idea]>, filtertType: IdeaType, isShowingCamera: Bool){
        self.loadedData = loadedData
        self._filteredIdeas = filteredIdeas
        self.filterType = filtertType
        self.isShowingCamera = isShowingCamera
            UISegmentedControl.appearance().backgroundColor = UIColor(Color("AccentColor")).withAlphaComponent(0.19)
            UISegmentedControl.appearance().setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("labelColor"))
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color("backgroundColor"))], for: .selected)
    }
    
    var body: some View {
        VStack{
            //segmented picker
            HStack{
                Picker("segmented picker", selection: $index){
                    Image(systemName: "list.bullet").tag(0)
                    Image(systemName: "square.grid.2x2").tag(1)
                }
                .pickerStyle(.segmented)
                .frame(width: 100)
                .padding()
                Spacer()
            }
                //define o tipo de visualização
            if index == 0{
                HomeListView(loadedData: loadedData, filteredIdeas: $filteredIdeas, filterType: filterType, isShowingCamera: isShowingCamera)
            } else{
                HomeGridView(loadedData: loadedData, filteredIdeas: $filteredIdeas, filterType: filterType, isShowingCamera: isShowingCamera)
            }
        }
    }
}

//struct SegmentedPickerComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        SegmentedPickerComponent(loadedData: [Idea], disposedData: [any Idea], filtertType: IdeaType.text, isShowingCamera: false)
//    }
//}

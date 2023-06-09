//
//  SegmentedPickerComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 07/06/23.
//

import SwiftUI
import UIKit

struct SegmentedPickerComponent: View {
    @State var index = 1
    
    //altera as cores do segmented picker
    init(){
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
            HomeListView()
        } else{
            HomeGridView()
        }
        }
    }
}

struct SegmentedPickerComponent_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedPickerComponent()
    }
}

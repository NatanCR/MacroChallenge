//
//  CellTemplate.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 30/05/23.
//

import SwiftUI

struct CellTemplate: View {
    var idea: any Idea
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 100)
                .foregroundColor(.gray)
                .overlay(alignment: .center) {
                    
                }
            VStack {
                Text("\(idea.title)")
                Text("\(TextViewModel.formatarData(idea.modifiedDate))")
            }.padding()
        }
    }
}
//
//struct CellTemplate_Previews: PreviewProvider {
//    static var previews: some View {
//        CellTemplate()
//    }
//}

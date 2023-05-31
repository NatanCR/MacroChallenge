//
//  CellTemplate.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 30/05/23.
//

import SwiftUI

struct CellTemplate: View {
    var model: ModelText
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(model.title)
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                Text(model.text)
                    .font(.system(size: 17, weight: .regular, design: .rounded))
            }
        }

    }
}
//
//struct CellTemplate_Previews: PreviewProvider {
//    static var previews: some View {
//        CellTemplate()
//    }
//}

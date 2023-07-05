//
//  TagSheetView.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 04/07/23.
//

import SwiftUI

struct TagSheetView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Text("Tags")
                    .font(Font.custom("Sen-Regular", size: 32, relativeTo: .headline))
                    .padding()
                Spacer()
            }.padding(.top, 50)
            
            //barra de pesquisa e registro de tag 
            Spacer()
        }
        .navigationBarTitle(Text("Tag"))
    }
}

struct TagSheetView_Previews: PreviewProvider {
    static var previews: some View {
        TagSheetView()
    }
}

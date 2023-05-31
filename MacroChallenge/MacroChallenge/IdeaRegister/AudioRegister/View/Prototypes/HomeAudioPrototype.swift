//
//  HomeAudioPrototype.swift
//  MacroChallenge
//
//  Created by Henrique Assis on 31/05/23.
//

import SwiftUI

struct HomeAudioPrototype: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: RecordAudioView()) {
                Text("Record Audio")
            }
        }
    }
}

struct HomeAudioPrototype_Previews: PreviewProvider {
    static var previews: some View {
        HomeAudioPrototype()
    }
}

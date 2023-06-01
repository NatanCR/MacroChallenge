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
            VStack {
                NavigationLink(destination: RecordAudioView()) {
                    Text("Record Audio")
                }
                
                if (!IdeaSaver.getSavedUniqueIdeasType(type: AudioIdeia.self, key: IdeaSaver.getAudioModelKey()).isEmpty) {
                    NavigationLink(destination: CheckAudioView(audioIdea: IdeaSaver.getSavedUniqueIdeasType(type: AudioIdeia.self, key: IdeaSaver.getAudioModelKey()).first!)) {
                        Text("See last Audio")
                    
                    }
                }
            }
        }
    }
}

struct HomeAudioPrototype_Previews: PreviewProvider {
    static var previews: some View {
        HomeAudioPrototype()
    }
}

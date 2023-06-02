//
//  HomeAudioPrototype.swift
//  MacroChallenge
//
//  Created by Henrique Assis on 31/05/23.
//

import SwiftUI

struct HomeAudioPrototype: View {
    @State var audioIdeas: [AudioIdeia] = IdeaSaver.getSavedUniqueIdeasType(type: AudioIdeia.self, key: IdeaSaver.getAudioModelKey())
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: RecordAudioView()) {
                    Text("Record Audio")
                }
                
                if (!IdeaSaver.getSavedUniqueIdeasType(type: AudioIdeia.self, key: IdeaSaver.getAudioModelKey()).isEmpty) {
                    NavigationLink(destination: CheckAudioView(audioIdea: audioIdeas.last!)) {
                        Text("See last Audio")
                    
                    }
                }
            }
        }.onAppear {
            //IdeaSaver.clearAll()
            audioIdeas = IdeaSaver.getSavedUniqueIdeasType(type: AudioIdeia.self, key: IdeaSaver.getAudioModelKey())
//            print(try? FileManager.default.contentsOfDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0], includingPropertiesForKeys: nil, options: .producesRelativePathURLs))
//            print("----")
//            print(audioIdeas.map({ $0.audioPath }))
        }
    }
}

struct HomeAudioPrototype_Previews: PreviewProvider {
    static var previews: some View {
        HomeAudioPrototype()
    }
}

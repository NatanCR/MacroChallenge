//
//  GroupListComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 20/09/23.
//

import SwiftUI

struct GroupListComponent: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.screenSize) var screenSize
    
    let audioManager: AudioManager = AudioManager()
    @ObservedObject var ideasViewModel: IdeasViewModel
    @Binding var isAdding: Bool
    @FocusState var isFocused: Bool
    @State var group: GroupModel
    @Binding var selectedIdeas: Set<UUID>
    private let removedIdeaNotification = NotificationCenter.default.publisher(for: NSNotification.Name("RemovedIdeaFromGroup"))
    @State var isIdeaNotGrouped = IdeaSaver.getIdeaNotGrouped()
    @Binding var ideaType: [any Idea]
    
    var body: some View {
        List(selection: $selectedIdeas) {
            ForEachGroupComponent(ideasViewModel: ideasViewModel, ideaType: $ideaType, isAdding: $isAdding, selectedIdeas: $selectedIdeas, group: group)
        }
    }
}

//struct GroupListComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupListComponent()
//    }
//}

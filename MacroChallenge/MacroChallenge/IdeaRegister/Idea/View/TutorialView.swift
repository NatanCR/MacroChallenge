//
//  TutorialView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 10/09/23.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.screenSize) var screenSize
    @Binding var tutorialPresented: Bool
    @State var index = 1
    
    var body: some View {
        
        //TODO: versão em inglês e versão para iPad
        NavigationView {
            
            VStack{
            }
                    .frame(width: screenSize.width, height: screenSize.height)
                    .background{
                        Image("tutorial-pt\(index)")
                    }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    if index<=4{
                        Button{
                            tutorialPresented = true
                            UserDefaults.standard.set(true, forKey: "hasShownTutorial")
                        } label: {
                            Text("Pular")
                        }
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    HStack(spacing: 210){
                        if index>1{
                            Button{
                                index = index - 1
                            } label: {
                                Text("Anterior")
                            }
                        }
                        
                        if index<=4{
                            Button{
                                index = index + 1
                            } label: {
                                Text("Próximo")
                            }
                            .padding(.trailing)
                            
                        } else {
                            Button{
                                tutorialPresented = true
                                UserDefaults.standard.set(true, forKey: "hasShownTutorial")
                            } label: {
                                Text("OK")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 10)
                                    .background{
                                        Capsule(style: .circular)
                                            .fill(Color("AccentColor"))
                                    }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .frame(width: screenSize.width, alignment: .trailing)

                }
                
                
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
}

//struct TutorialView_Previews: PreviewProvider {
//    @Environment(\.screenSize) var screenSize
//    static var previews: some View {
//        TutorialView()
//    }
//}

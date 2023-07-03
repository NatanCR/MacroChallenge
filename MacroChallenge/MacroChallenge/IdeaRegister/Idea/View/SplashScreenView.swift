//
//  SplashScreenView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 19/06/23.
//

import SwiftUI

struct SplashScreenView: View {
    @Environment(\.screenSize) var screenSize
    @State private var isActive = false //inicia a animação
    @State private var nextView = false
    @State var index = 1
    
    var body: some View {

            if nextView {
                HomeView()
                
            } else {
            ZStack{
                Color("splashScreen")
                    .ignoresSafeArea()
            //present the animation
            Image("splash_\(index)")
                .resizable()
                .scaledToFit()
                .frame(width: screenSize.width)
                .ignoresSafeArea()
                .onAppear{
                         
            //timer among the images
            Timer
                .scheduledTimer(withTimeInterval: 0.03, repeats: true){
                _ in
                                 
                                 
            //condition to call the images index
            if(index < 49) {
                index += 1
                                 }
                                 
                             }
            }
                .onAppear{
                           //turn isActive true to call the next view
                           DispatchQueue.main.asyncAfter(deadline: .now() + 2.4){
                               self.nextView = true
                           }
                       }
            }
            }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

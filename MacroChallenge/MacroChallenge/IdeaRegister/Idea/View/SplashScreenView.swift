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
                    Image("lamp")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .scaleEffect(self.isActive ? 1 : 0.1)
                        .animation(.easeIn(duration: 0.4), value: isActive)
                    
                }
                .onAppear{
                    isActive = true
                    
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    self.nextView = true
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

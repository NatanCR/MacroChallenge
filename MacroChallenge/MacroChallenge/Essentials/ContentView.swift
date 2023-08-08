////
////  ContentView.swift
////  MacroChallenge
////
////  Created by Natan de Camargo Rodrigues on 30/05/23.
////
//
import SwiftUI
//
struct ContentView: View {
    @State var text = String()
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Sen-Bold", size: 30)!]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: "Sen-Bold", size: 17)!]
        
        UISearchBar.appearance().showsBookmarkButton = true
        UISearchBar.appearance().setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .bookmark, state: .normal)
        UISearchBar.appearance().setSize(.init(width: 300, height: 100))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(1..<50) { index in
                    Text("Sample Row Nr.\(index)")
                }
            }
            .navigationTitle("Navigation")
            .searchable(text: $text, placement: .navigationBarDrawer(displayMode: .automatic))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UISearchBar {
    public func setSize(_ size: CGSize) {
//        self.addSubview(UITextView().text = "teste")
    }
}

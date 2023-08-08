//
//  SearchBarComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI
import UIKit

struct SearchBarComponent: View {    
    @State var searchText: String = String()
    @State var textFieldEstaEditando: Bool = false
    @ObservedObject var ideasViewModel: IdeasViewModel
    
    //MARK: - BODY
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("labelColor"))
                    .opacity(0.5)
                TextField("search", text: $searchText)
                    .foregroundColor(Color("labelColor"))
                    .keyboardType(.default)
                    .disabled(self.textFieldEstaEditando)
                
                    .onChange(of: searchText) { _ in
                        self.resetSearchText(false)
                        self.ideasViewModel.filteredIdeas = ideasViewModel.filteringIdeas
                    }
            }
            .onAppear(perform: { self.resetSearchText() })
            .padding(UIDevice.current.userInterfaceIdiom == .phone ? 7 : 15)
            .background(Color("backgroundItem"))
            .opacity(0.8)
            .cornerRadius(8)
            .padding(.leading, 10)
        }
    }
    
    //MARK: - FUNCs
    private func resetSearchText(_ clearText: Bool = true) {
        if clearText {
            self.searchText = String()
        }
        
        self.ideasViewModel.searchText = self.searchText
    }
}

struct NavigationSearchController: UIViewControllerRepresentable {
    typealias UIViewControllerType = Wrapper
    
    //MARK: - FUNCs
    func makeCoordinator() -> Coordinator {
        Coordinator(representable: self)
    }
    
    func makeUIViewController(context: Context) -> Wrapper {
        Wrapper()
    }
    
    func updateUIViewController(_ wrapper: Wrapper, context: Context) {
        wrapper.searchController = context.coordinator.searchController
    }
    
    //MARK: - COORDINATOR
    class Coordinator : NSObject, UISearchResultsUpdating {
        let representable: NavigationSearchController
        let searchController: UISearchController
        
        init(representable: NavigationSearchController) {
            self.representable = representable
            self.searchController = UISearchController(searchResultsController: nil)
            super.init()
            
            // Set up search bar properties
            searchController.searchResultsUpdater = self
            searchController.searchBar.placeholder = "Search"
            searchController.searchBar.searchBarStyle = .default
        }
        
        func updateSearchResults(for searchController: UISearchController) {
            print("update search")
        }
    }
    
    //MARK: - WRAPPER
    class Wrapper : UIViewController {
        var searchController : UISearchController? {
            get {
                self.parent?.navigationItem.searchController
            }
            set {
                self.parent?.navigationItem.searchController = newValue
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            searchController?.isActive = true
        }
    }
}

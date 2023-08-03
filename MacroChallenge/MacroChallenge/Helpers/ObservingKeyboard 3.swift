//
//  ObservingKeyboard.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 04/07/23.
//

import Foundation
import SwiftUI
import Combine

//Para fazer com que o botão da toolbar acompanhe o movimento do teclado e suba junto com ele, ObservingKeyboard monitora as notificações do teclado e ajusta a posição do botão de acordo

class ObservingKeyboard: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let show = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height }
        
        let hide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in 0 }
        
        show.merge(with: hide)
            .subscribe(on: DispatchQueue.main)
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
    }
}

//
//  BackAction.swift
//  MacroChallenge
//
//  Created by Henrique Assis on 19/06/23.
//

import Foundation
import UIKit
import SwiftUI

//MARK: - UIKIT
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.addTarget(self, action: #selector(onSwipePopGesture))
    }
    
    @objc func onSwipePopGesture() {
        if interactivePopGestureRecognizer?.state == .recognized {
            NotificationCenter.default.post(name: NSNotification.Name("SwipeBack"), object: nil)
        }
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

// MARK: - SWIFTUI
struct SwipeBackModifier : ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("SwipeBack"), object: nil, queue: nil) { _ in
                    action()
                }
            }
    }
}

extension View {
    func onSwipeBack(perform action: @escaping () -> Void) -> some View {
        self.modifier(SwipeBackModifier(action: action))
    }
}

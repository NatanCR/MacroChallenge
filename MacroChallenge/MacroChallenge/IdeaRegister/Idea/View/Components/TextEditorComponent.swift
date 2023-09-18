//
//  TextEditorComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 30/08/23.
//

import SwiftUI

struct TextEditorComponent: View {
    @Binding var text: NSAttributedString // Use NSAttributedString instead of String
    @State var selectedText: String = ""
    
    init(text: Binding<NSAttributedString>){
        self._text = text
        UITextView.appearance().textColor = UIColor(Color("labelColor"))
        UITextView.appearance().font = UIFont(name: "Sen-Regular", size: 17)
    }
    
    var body: some View {
        UITextViewRepresentable(text: $text, selectedText: $selectedText)
    }
}

struct UITextViewRepresentable: UIViewRepresentable {
    let textView = UITextView()
    @Binding var text: NSAttributedString
    @Binding var selectedText: String

    func makeUIView(context: Context) -> UITextView {
        //enable the format button on the edit menu
        textView.allowsEditingTextAttributes = true

        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        // SwiftUI -> UIKit
        uiView.attributedText = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, selectedText: $selectedText)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: NSAttributedString
        @Binding var selectedText: String

        init(text: Binding<NSAttributedString>, selectedText: Binding<String>) {
            self._text = text
            self._selectedText = selectedText
        }

        func textViewDidChange(_ textView: UITextView) {
            // UIKit -> SwiftUI
            _text.wrappedValue = textView.attributedText

        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            // Reset typing attributes to default if formatting was applied
                textView.typingAttributes = [
                    NSAttributedString.Key.font: UIFont(name: "Sen-Regular", size: 17) ?? .systemFont(ofSize: 17),
                    NSAttributedString.Key.foregroundColor: UIColor.black
                ]

        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if !selectedText.isEmpty {
                // Apply attributes to the selected range
                let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)

                // Replace the selected text with the new text while preserving formatting
                attributedText.replaceCharacters(in: textView.selectedRange, with: text)

                textView.attributedText = attributedText
                _text.wrappedValue = attributedText
                selectedText = ""

                return false
            }
            return true
        }
    }

}


//struct TextEditorComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        TextEditorComponent()
//    }
//}

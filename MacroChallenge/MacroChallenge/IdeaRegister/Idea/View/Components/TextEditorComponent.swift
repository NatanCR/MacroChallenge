//
//  TextEditorComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 30/08/23.
//

import SwiftUI

struct TextEditorComponent: View {
    @Binding var text: String
    @State var font: UIFont?
    @State var selectedText: String = ""
    
    init(text: Binding<String>, font: UIFont?){
        self._text = text
        self.font = font
        UITextView.appearance().textColor = UIColor(Color("labelColor"))
        UITextView.appearance().font = font
    }
    
    var body: some View {
        UITextViewRepresentable(text: $text, selectedText: $selectedText)
            .onChange(of: selectedText) { newValue in
                print("range - \(selectedText)")
            }
    }
}

//view de texto que reconhece texto selecionado
struct UITextViewRepresentable: UIViewRepresentable {
    let textView = UITextView()
    @Binding var text: String
    @Binding var selectedText: String
    
    func makeUIView(context: Context) -> UITextView {
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        // SwiftUI -> UIKit
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, selectedText: $selectedText)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        @Binding var selectedText: String
        
        init(text: Binding<String>, selectedText: Binding<String>) {
            self._text = text
            self._selectedText = selectedText
        }
        
        func textViewDidChange(_ textView: UITextView) {
            // UIKit -> SwiftUI
            _text.wrappedValue = textView.text
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            
            if let range = textView.selectedTextRange{
                selectedText = textView.text(in: range) ?? String()
            }
            // Fires off every time the user changes the selection.
            print(textView.selectedRange)
        }
    }
}

//struct TextEditorComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        TextEditorComponent()
//    }
//}

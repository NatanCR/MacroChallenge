//
//  RecordAudioView.swift
//  MacroChallenge
//
//  Created by Henrique Assis on 31/05/23.
//

import SwiftUI
import AVFoundation

struct RecordAudioView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.screenSize) private var screenSize
    
    // audio states
    @StateObject var recordAudio: RecordAudio
    @State var isRecording: Bool = true
    @State var recorded: Bool = false
    @State var audioUrl: URL?
    
    // text states
    @State var textComplete: String = ""
    @State var textTitle: String = ""
    @State var textDescription: String = ""
    @FocusState var isFocused: Bool
    
    // permission
    @State var isAllowed: Bool = false
    @State var recordPermission: Bool = {
        if let value = UserDefaults.standard.object(forKey: "AudioPermission") as? Bool {
            return value
        } else {
            return true
        }
    }()
    
    // alerts
    @State private var cancelAlertIsActive: Bool = false
    @State private var saveAlertIsActive: Bool = false
    
    @ObservedObject var ideasViewModel: IdeasViewModel
    @State var showModal: Bool = false
    @State var tagsArray: [Tag] = []
    @State var colorName: String = ""
    
    
    // audio
    private let audioManager: AudioManager
    
    //MARK: - INIT
    init(ideasViewModel: IdeasViewModel) {
        self._recordAudio = StateObject(wrappedValue: RecordAudio())
        self.audioManager = AudioManager()
        self.ideasViewModel = ideasViewModel
    }
    
    //MARK: - BODY
    var body: some View {
        VStack(alignment: .leading){
            VStack(alignment: .center) {
                
                TextEditor(text: $textComplete)
                    .frame(maxWidth: screenSize.width, maxHeight: screenSize.height * 0.8, alignment: .topLeading)
                    .focused($isFocused)
                    .overlay {
                        Text(self.textComplete.isEmpty ? "typeNote" : "")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(8)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                self.isFocused = true
                            }
                    }
                    .padding()
                
                if isAllowed {
                    // recording indicator
                    if self.isRecording {
                        Text("record")
                            .foregroundColor(Color("deleteColor"))
                            .padding()
                        
                        Button{
                            self.recordAction()
                        } label: {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 28))
                        }
                        
                        
                    } else if (self.recorded) {
                        HStack(alignment: .center) {
                            AudioReprodutionComponent(audioManager: self.audioManager, audioURL: ContentDirectoryHelper.getDirectoryContent(contentPath: self.audioUrl!.lastPathComponent))
                                .frame(maxHeight: screenSize.height * 0.05)
                            Button {
                                self.deleteAction()
                                
                                //                        self.recordAudio.deleteAllAudios()
                                //                        IdeaSaver.clearAll()
                            } label: {
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 23))
                                    .foregroundColor(Color("deleteColor"))
                            }
                            
                        }
                        .padding()
                    }
                    
                    HStack{
                        if tagsArray.isEmpty {
                            Button{
                                self.showModal = true
                            } label: {
                                Image("tag_icon")
                            }
                        } else {
                            Button {
                                self.showModal = true
                            } label: {
                                IdeaTagViewerComponent(colorName: colorName, idea: AudioIdea(title: textTitle, description: textDescription, textComplete: textComplete, creationDate: Date(), modifiedDate: Date(), audioPath: self.audioUrl?.lastPathComponent ?? "", tag: self.tagsArray))
                            }
                        }
                        
                        Spacer()
                        
                        //botão de gravar
                        if !isRecording && !recorded {
                            Button{
                                self.recordAction()
                            } label: {
                                Image(systemName: "mic.badge.plus")
                                    .font(.system(size: 28))
                            }
                        }
                        
                    }
                    .padding(30)
                    
                    
                }
            }
        }
        .sheet(isPresented: $showModal) {
            TagView(viewModel: ideasViewModel, tagsArrayReceived: $tagsArray, colorName: $colorName)
        }
        // alerts
        .alert("cancelIdea", isPresented: $cancelAlertIsActive, actions: {
            Button(role: .destructive) {
                self.backAction()
                dismiss()
            } label: {
                Text("yes")
            }
            
            Button(role: .cancel) {
                self.cancelAlertIsActive = false
            } label: {
                Text("no")
            }
        })
        .alert("saveNoAudio", isPresented: $saveAlertIsActive, actions: {
            Button(role: .cancel) {
                self.saveAlertIsActive = false
            } label: {
                Text("OK")
            }
        })
        .font(.custom("Sen-Regular", size: 17, relativeTo: .headline))
        .navigationTitle("insertAud")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("save") {
                    self.saveAction()
                }
                .font(.custom("Sen-Regular", size: 17))
            }
            
            //back button personalizado
            ToolbarItem(placement: .navigationBarLeading) {
                CustomActionBackButtonComponent (image:"", buttonText: "cancel", willDismiss: false, action: {
                    cancelAlertIsActive = true
                })
            }
            
            ToolbarItem(placement: .keyboard) {
                if showModal{
                    SelectColorView(colorName: $colorName)
                }
            }
        }.onAppear {
            self.recordAudio.requestPermission { isAllowed in
                if isAllowed {
                    DispatchQueue.main.async {
                        self.isAllowed = true
                        self.startRecord()
                    }
                }
                
                else {
                    if recordPermission {
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(false, forKey: "AudioPermission")
                            dismiss()
                        }
                    }
                    
                    else {
                        permisisonAlert()
                    }
                }
            }
            
        }
    }
    
    //MARK: - FUNCS
    /**Starts the record audio action in general.*/
    private func startRecord() {
        self.isFocused = false
        self.audioUrl = nil
        self.recordAudio.startRecordingAudio()
    }
    
    /**The action that is realised when pressing the back button.*/
    private func backAction() {
        if self.isRecording && !self.recorded {
            self.recordAudio.stopRecordingAudio()
            self.recordAudio.deleteAudio(audioPath: self.recordAudio.recordedAudioPath)
        }
        
        else if self.recorded {
            self.recordAudio.deleteAudio(audioPath: self.recordAudio.recordedAudioPath)
            self.recorded = false
        }
    }
    
    /**The action that is realised when pressing the save button.*/
    private func saveAction() {
        if isRecording {
            self.recordAction()
        }
        
        if recorded {
            TextViewModel.setTitleDescriptionAndCompleteText(title: &self.textTitle, description: &self.textDescription, complete: &self.textComplete)
            
            let idea = AudioIdea(title: self.textTitle, description: self.textDescription, textComplete: self.textComplete, creationDate: Date(), modifiedDate: Date(), audioPath: self.audioUrl?.lastPathComponent ?? "", tag: tagsArray)
            IdeaSaver.saveAudioIdea(idea: idea)
            dismiss()
        }
        else {
            self.saveAlertIsActive = true
        }
        
    }
    
    /**The action that is realised when pressing the record/stop button.*/
    private func recordAction() {
        self.isRecording.toggle()
        
        // if started recording
        if isRecording {
            self.recordAudio.startRecordingAudio()
            
        } else { // if stop the record
            self.recordAudio.stopRecordingAudio()
            self.audioUrl = ContentDirectoryHelper.getDirectoryContent(contentPath: self.recordAudio.recordedAudioPath)
            self.audioManager.assignAudio(self.audioUrl!)
            self.recorded = true
        }
    }
    
    /**The action that is realised when pressing the delete button.*/
    private func deleteAction() {
        self.recorded = false
        self.audioManager.stopAudio()
        self.recordAudio.deleteAudio(audioPath: self.recordAudio.recordedAudioPath)
    }
    
    /**Alert that is poped up when trying to acces the record audio with no authorization.*/
    private func permisisonAlert() {
        let denied = String.LocalizationValue(stringLiteral: "denied")
        let micDeny = String.LocalizationValue(stringLiteral: "micDenyMessage")
        let cancel = String.LocalizationValue(stringLiteral: "cancel")
        let openConfig = String.LocalizationValue(stringLiteral: "openConfig")
        
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            let alert = UIAlertController(title: String(localized: denied), message: String(localized: micDeny), preferredStyle: .alert)
            
            //Obtém a cena de janela ativa
            if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = UIViewController()
                window.windowLevel = UIWindow.Level.alert + 1
                window.makeKeyAndVisible()
                window.rootViewController?.present(alert, animated: true, completion: nil)
                
                alert.addAction(UIAlertAction(title: String(localized: cancel), style: .default, handler: { _ in
                    window.rootViewController?.dismiss(animated: true, completion: nil)
                    dismiss()
                }))
                alert.addAction(UIAlertAction(title: String(localized: openConfig), style: .cancel, handler: { _ in
                    window.rootViewController?.dismiss(animated: true, completion: nil)
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                }))
            }
        }
    }
}

//struct RecordAudioView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordAudioView()
//    }
//}

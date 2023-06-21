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
    
    // audio
    private let audioManager: AudioManager
    
    //MARK: - INIT
    init() {
        self._recordAudio = StateObject(wrappedValue: RecordAudio())
        self.audioManager = AudioManager()
    }
    
    //MARK: - BODY
    var body: some View {
        VStack {
            if isAllowed {
                // recording indicator
                if self.isRecording {
                    Text("record")
                        .foregroundColor(Color("deleteColor"))
                        .padding()
                } else if (self.recorded) {
                    HStack(alignment: .top) {
                        AudioReprodutionComponent(audioManager: self.audioManager, audioURL: ContentDirectoryHelper.getDirectoryContent(contentPath: self.audioUrl!.lastPathComponent))
                            .frame(maxHeight: screenSize.height * 0.05)
                        
                        Button {
                            self.recorded = false
                            self.audioManager.stopAudio()
                            self.recordAudio.deleteAudio(audioPath: self.recordAudio.recordedAudioPath)
                            
    //                        self.recordAudio.deleteAllAudios()
    //                        IdeaSaver.clearAll()
                        } label: {
                            Image(systemName: "trash.fill")
                                .resizable()
                                .foregroundColor(Color("deleteColor"))
                                .frame(width: 23, height: 23)
                        }
                    }
                    .padding()
                }
                
                // record and stop button
                Button {
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
                } label: {
                    Image(systemName: self.isRecording ? "stop.fill" : "mic.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 23, height: 23)
                }.disabled(self.recorded)
                
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
            }
        }
        .font(.custom("Sen-Regular", size: 20, relativeTo: .headline))
        .navigationTitle("Inserir áudio")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Salvar") {
                    if isRecording {
                        self.recordAudio.stopRecordingAudio()
                        self.recordAudio.deleteAudio(audioPath: self.recordAudio.recordedAudioPath)
                        self.recorded = false
                    }
                    
                    if recorded {
                        TextViewModel.setTitleDescriptionAndCompleteText(title: &self.textTitle, description: &self.textDescription, complete: &self.textComplete)
                        
                        let idea = AudioIdeia(title: self.textTitle, description: self.textDescription, textComplete: self.textComplete, creationDate: Date(), modifiedDate: Date(), audioPath: self.audioUrl?.lastPathComponent ?? "")
                        IdeaSaver.saveAudioIdea(idea: idea)
                    }
                    
                    dismiss()
                }
            }
        }.onAppear {
            recordAudio.requestPermission { isAllowed in
                if isAllowed {
                    DispatchQueue.main.async {
                        self.isAllowed = true
                        startRecord()
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
    func startRecord() {
        self.isFocused = false
        self.audioUrl = nil
        self.recordAudio.startRecordingAudio()
    }
    
    func permisisonAlert() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            let alert = UIAlertController(title: "Permissão negada", message: "Você negou permissão para acessar o microfone. Deseja abrir as configurações para conceder permissão?", preferredStyle: .alert)
            
            //Obtém a cena de janela ativa
            if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = UIViewController()
                window.windowLevel = UIWindow.Level.alert + 1
                window.makeKeyAndVisible()
                window.rootViewController?.present(alert, animated: true, completion: nil)
                
                alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: { _ in
                    window.rootViewController?.dismiss(animated: true, completion: nil)
                    dismiss()
                }))
                alert.addAction(UIAlertAction(title: "Abrir configurações", style: .cancel, handler: { _ in
                    window.rootViewController?.dismiss(animated: true, completion: nil)
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                }))
            }
        }
    }
}

struct RecordAudioView_Previews: PreviewProvider {
    static var previews: some View {
        RecordAudioView()
    }
}

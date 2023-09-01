//
//  TagView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 05/07/23.
//

import SwiftUI

struct TagView: View {
    @Environment(\.screenSize) var screenSize
    @State var tagName: String = ""
    @FocusState private var isFocused: Bool
    @ObservedObject var viewModel: IdeasViewModel //pego as tags ja salvas
    @Binding var tagsArrayReceived: [Tag]
    @State private var thatTagExist: Bool = false
    @State private var newTag: Tag?
    @Binding var colorName: String //recebe a cor da tag
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                //indicador da sheet
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("labelColor"))
                    .frame(width: screenSize.width * 0.5, height: screenSize.height * 0.005)
                //título
                Text("Tags")
                    .font(.custom("Sen-Bold", size: 30))
                    .frame (maxWidth: .infinity, alignment:
                            .leading)
                    .padding(.vertical)
                HStack{
                    //Text Field
                    TextField("addTag", text: $tagName, onCommit: {
                        self.tagName = self.tagName.trimmingCharacters(in: .whitespaces)
                        
                        if tagName.isEmpty {
                           print("esta vazio")
                        } else {
                            self.thatTagExist = viewModel.verifyExistTags(newTagName: self.tagName)
                            
                            if !thatTagExist {
                                
                                newTag = Tag(name: self.tagName, color: self.colorName)
                                
                                viewModel.saveTagAndUpdateListView(tagToSave: newTag ?? Tag(name: "", color: self.colorName))
                                
                                self.newTag?.isTagSelected = true
                                
                                self.tagsArrayReceived.append(newTag ?? Tag(name: "", color: self.colorName))
                            }
                            
                        }
                    })
                    .onSubmit {
                        self.tagName = ""
                        self.colorName = ""
                    }
                    //realize a busca da tag
                    .onChange(of: tagName, perform: { _ in
                        self.resetSearchTag(false)
                        self.viewModel.tagsFiltered = viewModel.updateSelectedTags(allTags: viewModel.filteringTags, tagSelected: self.tagsArrayReceived)
                    })
                    .font(.custom("Sen-Regular", size: 17))
                    .foregroundColor(Color("labelColor"))
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color("labelColor").opacity(0.5), lineWidth: 1)
                    )
                    .focused($isFocused)
                    
                    //mostra o botão de adicionar quando clica no text field
                    if isFocused {
                        Button{
                            //adicionando tags
                            self.tagName = self.tagName.trimmingCharacters(in: .whitespaces)
                            if tagName.isEmpty {
                               print("esta vazio")
                            } else {
                                self.thatTagExist = viewModel.verifyExistTags(newTagName: self.tagName)
                                if !thatTagExist {
                                    newTag = Tag(name: self.tagName, color: self.colorName)
//                                    viewModel.saveTagAndUpdateListView(tagName: self.tagName, tagColor: "fff")
                                    viewModel.saveTagAndUpdateListView(tagToSave: newTag ?? Tag(name: "", color: self.colorName))
                                    
                                    self.newTag?.isTagSelected = true
                                    self.tagsArrayReceived.append(newTag ?? Tag(name: "", color: self.colorName))
                                    //viewModel.saveTagAndUpdateListView(tagName: self.tagName, tagColor: colorName)
                                    colorName = ""
                                }
                            }
                            
                            tagName = ""
                            isFocused = false
                        } label: {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 30))
                        }
                        
                        //desabilitando botão quando o text field estiver vazio
                        .disabled(tagName == "")
                        .opacity (tagName == "" ? 0.6 : 1)
                    }
                }
                
                //Lista de tag
                TagComponent(allTags: $viewModel.tagsFiltered, tagArraySelected: $tagsArrayReceived, viewModel: viewModel, colorName: colorName)
                    .padding(.top, 20)
            }
            .onAppear {
                self.resetSearchTag()
            }
            
            .padding(15)
            .frame(maxWidth: proxy.size.width, maxHeight: proxy.size.height, alignment: .top)
            .background(Color("backgroundColor"))
            .onTapGesture {
                isFocused = false
                colorName = ""
            }
            .alert("sameTag", isPresented: $thatTagExist, actions: {
                Button(role: .cancel) {
                } label: {
                    Text("OK")
                }
            }, message: {
                Text("msgTag")
            })
        }
    }
    
    private func resetSearchTag(_ clearTag: Bool = true) {
        if clearTag {
            self.tagName = String()
        }
        
        self.viewModel.searchTag = self.tagName
    }
}


//struct TagView_Previews: PreviewProvider {
//    static var previews: some View {
//        TagView()
//    }
//}

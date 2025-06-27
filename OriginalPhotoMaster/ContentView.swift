//
//  ContentView.swift
//  OriginalPhotoMaster
//
//  Created by Yoshito Usui on 2025/06/26.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State var selectedItem: PhotosPickerItem?
    @State var selectedImage: Image? = nil
    @State var text: String = ""
    @State private var showAlert: Bool = false
    @State private var isShowingShareSheet = false
    @State private var sharedImage: UIImage? = nil
    @State private var cardcolor:Color = .white
    
    var body: some View {
        VStack(spacing: 20) {
            imageWithFrame
            HStack{
                Button(action: {
                    cardcolor = .white
                }){
                    
                }
                .fontWeight(.semibold)
                .frame(width: 48, height: 48)
                .background(Color(.white))
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.black, lineWidth: 2)
                )
                
                Button(action: {
                    cardcolor = .pink
                }) {
                        
                }
                .fontWeight(.semibold)
                .frame(width: 48, height: 48)
                .background(Color(.pink))
                .cornerRadius(24)
                
                Button(action: {
                    cardcolor = .yellow
                }) {
                        
                }
                .fontWeight(.semibold)
                .frame(width: 48, height: 48)
                .background(Color(.yellow))
                .cornerRadius(24)
            }
            .padding(.horizontal)
            
            TextField("テキストを入力", text: $text)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 10))
                .padding(.horizontal)
          
            Button {
                isShowingShareSheet = true
            } label: {
                HStack {
                    Text("共有する")
                    Image(systemName: "square.and.arrow.up")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal)
            .disabled(selectedImage == nil)
            
            
        }
        .onChange(of: selectedItem, initial: true) {
            loadImage()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("保存完了"), message: Text("画像がフォトライブラリに保存されました。"), dismissButton: .default(Text("OK")))
        }
        // シートとして表示
        .sheet(isPresented: $isShowingShareSheet) {
            if let image = sharedImage {
                ShareSheet(activityItems: [image, "共有画像"])
            }
        }
    }
    
    var imageWithFrame: some View {
        Rectangle()
            .fill(cardcolor)
            .frame(width: 350, height: 520)
            .shadow(radius: 10)
            .overlay {
                ZStack {
                    VStack(spacing: 25) {
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 300, height: 400)
                            .overlay {
                                if let displayImage = selectedImage {
                                    displayImage
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 300, height: 400)
                                        .clipped()
                                } else {
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .padding(20)
                                        .background(Color.gray.opacity(0.7))
                                        .clipShape(.circle)
                                }
                            }
                        Text(text)
                            .font(.custom("yosugara ver12", size: 40))
                            .foregroundStyle(.black)
                            .frame(height: 40)
                    }
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Color.clear
                            .contentShape(.rect)
                    }
                }
            }
    }
    
    private func loadImage() {
        guard let item = selectedItem else { return }
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data, let uiImage = UIImage(data: data) {
                    selectedImage = Image(uiImage: uiImage)
                } else {
                }
            case .failure(let error):
                print("画像の読み込みに失敗しました: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveEditedImage() {
        let renderer = ImageRenderer(content: imageWithFrame)
        renderer.scale = 3
        
        if let uiImage = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
            showAlert = true
            selectedImage = nil
            selectedItem = nil
            text = ""
        }
    }
}

#Preview {
    ContentView()
}

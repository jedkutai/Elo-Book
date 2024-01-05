//
//  CreatePostView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI
import PhotosUI
import UIKit

struct CreatePostView: View {
    @Binding var isCropViewPresented: Bool
    @Binding var posting: Bool
    @Binding var currentView: createPostViewShown
    @Binding var selectedImages: [PhotosPickerItem]
    @Binding var caption: String
    
    
    @ObservedObject var viewModel: UploadPost
    @State private var targetImage: Int = 0
    var dismiss: DismissAction
    private let screenHeight = UIScreen.main.bounds.height
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                    }
                    
                    Spacer()
                    
                    Text("\(1000 - caption.count)")
                        .foregroundStyle(caption.count < 1000 ? Theme.textColor : Color(.systemRed))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    if (!viewModel.postImages.isEmpty && caption.isEmpty) || Checks.isValidCaption(caption)  {
                        Button {
                            currentView = .addEvents
                            
                        } label: {
                            Text("Continue")
                                .foregroundColor(.blue)
                        }
                    } else {
                        Text("Continue")
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .frame(height: 1)
                
                VStack {
                    TextField("Enter your caption...", text: $caption, axis: .vertical)
                    Spacer()
                }
                .padding()

                if !viewModel.uiImages.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(viewModel.uiImages, id: \.self) { image in
                                Button {
                                    if let index = viewModel.uiImages.firstIndex(of: image) {
                                        targetImage = index
                                        isCropViewPresented.toggle()
                                    }
                                } label: {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 30, height: 30)
                                        .clipped()
                                        .padding(.leading, 1)
                                }
                            }
                        }
                    }
                    .frame(height: 30)
                    .padding(.horizontal)
                }
                
                Spacer()
                
                Divider()
                    .frame(height: 1)
                
                PhotosPicker(selection: $selectedImages, maxSelectionCount: 4, selectionBehavior: .default, matching: .images, preferredItemEncoding: .current) {
                    Text("Select Photos")
                }
                .photosPickerStyle(.inline)
                .ignoresSafeArea()
                .photosPickerDisabledCapabilities(.selectionActions)
                .photosPickerAccessoryVisibility(.hidden, edges: .bottom)
                .frame(height: screenHeight * 0.5)
                
            }
            .ignoresSafeArea(.keyboard)
            .onTapGesture {
                hideKeyboard()
            }
            .onChange(of: selectedImages) {
                viewModel.uiImages = []
                Task {
                    await viewModel.loadImages(fromItem: selectedImages)
                }
            }
            .sheet(isPresented: $isCropViewPresented) {
                CropImageViewController(image: $viewModel.uiImages[targetImage])
            }
        }
    }
}

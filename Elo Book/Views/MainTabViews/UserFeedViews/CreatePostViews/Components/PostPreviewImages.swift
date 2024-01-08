//
//  PostPreviewImages.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/6/24.
//

import SwiftUI
import PhotosUI
import UIKit

struct PostPreviewImages: View {
    
    @ObservedObject var viewModel: UploadPost
    private let imageWidth = UIScreen.main.bounds.width * 0.85
    
    
    var body: some View {
        Group {
            if viewModel.uiImages.count == 1 {
                one
            } else if viewModel.uiImages.count == 2 {
                two
            } else if viewModel.uiImages.count == 3 {
                three
            } else if viewModel.uiImages.count == 4 {
                four
            }
        }
        
    }

    var one: some View {
        Button {
            
        } label: {
            Image(uiImage: viewModel.uiImages[0])
                .resizable()
                .scaledToFill()
                .frame(width: imageWidth, height: imageWidth * 0.5 + 5)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 8)
        }
            
    }

    var two: some View {
        HStack {
            Button {
                
            } label: {
                Image(uiImage: viewModel.uiImages[0])
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageWidth * 0.5 - 0.5, height: imageWidth * 0.5 + 5)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.leading, 8)
            }
                
            
            Spacer()
            
            Button {
                
            } label: {
                Image(uiImage: viewModel.uiImages[1])
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageWidth * 0.5 - 0.5, height: imageWidth * 0.5 + 5)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.trailing, 8)
            }
                
        }
        .frame(width: imageWidth)
    }
    
    var three: some View {
        HStack {
            Button {
                
            } label: {
                Image(uiImage: viewModel.uiImages[0])
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.5 + 5)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.leading, 8)
            }
                
            
            Spacer()
            
            VStack {
                Button {
                    
                } label: {
                    Image(uiImage: viewModel.uiImages[1])
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25 - 0.25)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                    
                    
                Spacer()
                
                Button {
                    
                } label: {
                    Image(uiImage: viewModel.uiImages[2])
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25 - 0.25)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                    
            }
            .frame(height: imageWidth * 0.5 + 5)
            .padding(.trailing, 8)
        }
    }
    
    var four: some View {
        VStack {
            HStack {
                Button {
                    
                } label: {
                    Image(uiImage: viewModel.uiImages[0])
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.leading, 8)
                }
                    
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(uiImage: viewModel.uiImages[1])
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.trailing, 8)
                }
                    
            }
            .frame(width: imageWidth)
            .padding(.bottom, 5)
            
            HStack {
                Button {
                    
                } label: {
                    Image(uiImage: viewModel.uiImages[2])
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.leading, 8)
                }
                    
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(uiImage: viewModel.uiImages[3])
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.trailing, 8)
                }
                    
            }
            .frame(width: imageWidth)
        }
    }
}

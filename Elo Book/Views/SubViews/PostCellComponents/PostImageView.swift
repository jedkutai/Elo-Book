//
//  PostImageView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

import SwiftUI
import Kingfisher

struct PostImageView: View {
    @State var imageUrls: [String]
    
    private let imageWidth = UIScreen.main.bounds.width * 0.85
    var body: some View {
        Group {
            if imageUrls.count == 1 {
                one
            } else if imageUrls.count == 2 {
                two
            } else if imageUrls.count == 3 {
                three
            } else if imageUrls.count == 4 {
                four
            }
        }
        
    }

    var one: some View {
        NavigationStack {
            NavigationLink {
                PostImageExpandedView(imageUrls: imageUrls, centeredImage: 0)
            } label: {
                KFImage(URL(string: imageUrls[0]))
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageWidth, height: imageWidth * 0.5 + 5)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 8)
            }
        }
            
    }

    var two: some View {
        NavigationStack {
            HStack {
                NavigationLink {
                    PostImageExpandedView(imageUrls: imageUrls, centeredImage: 0)
                } label: {
                    KFImage(URL(string: imageUrls[0]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageWidth * 0.5 - 0.5, height: imageWidth * 0.5 + 5)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.leading, 8)
                }
                    
                
                Spacer()
                
                NavigationLink {
                    PostImageExpandedView(imageUrls: imageUrls, centeredImage: 1)
                } label: {
                    KFImage(URL(string: imageUrls[1]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageWidth * 0.5 - 0.5, height: imageWidth * 0.5 + 5)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.trailing, 8)
                }
                    
            }
            .frame(width: imageWidth)
        }
    }
    
    var three: some View {
        NavigationStack {
            HStack {
                NavigationLink {
                    PostImageExpandedView(imageUrls: imageUrls, centeredImage: 0)
                } label: {
                    KFImage(URL(string: imageUrls[0]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.5 + 5)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.leading, 8)
                }
                    
                
                Spacer()
                
                VStack {
                    NavigationLink {
                        PostImageExpandedView(imageUrls: imageUrls, centeredImage: 1)
                    } label: {
                        KFImage(URL(string: imageUrls[1]))
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25 - 0.25)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                        
                        
                    Spacer()
                    
                    NavigationLink {
                        PostImageExpandedView(imageUrls: imageUrls, centeredImage: 2)
                    } label: {
                        KFImage(URL(string: imageUrls[2]))
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
    }
    
    var four: some View {
        NavigationStack {
            VStack {
                HStack {
                    NavigationLink {
                        PostImageExpandedView(imageUrls: imageUrls, centeredImage: 0)
                    } label: {
                        KFImage(URL(string: imageUrls[0]))
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.leading, 8)
                    }
                        
                    
                    Spacer()
                    
                    NavigationLink {
                        PostImageExpandedView(imageUrls: imageUrls, centeredImage: 1)
                    } label: {
                        KFImage(URL(string: imageUrls[1]))
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
                    NavigationLink {
                        PostImageExpandedView(imageUrls: imageUrls, centeredImage: 2)
                    } label: {
                        KFImage(URL(string: imageUrls[2]))
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.leading, 8)
                    }
                        
                    
                    Spacer()
                    
                    NavigationLink {
                        PostImageExpandedView(imageUrls: imageUrls, centeredImage: 3)
                    } label: {
                        KFImage(URL(string: imageUrls[3]))
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
}

#Preview {
    PostImageView(imageUrls: [])
}

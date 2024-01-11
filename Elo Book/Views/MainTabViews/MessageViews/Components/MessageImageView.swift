//
//  PostImageView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI
import Kingfisher

struct MessageImageView: View {
    @State var imageUrls: [String]
    
    @State private var showImages = false
    
    
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
                MessageImageExpandedView(imageUrls: imageUrls, centeredImage: 0)
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
                    MessageImageExpandedView(imageUrls: imageUrls, centeredImage: 0)
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
                    MessageImageExpandedView(imageUrls: imageUrls, centeredImage: 1)
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
                    MessageImageExpandedView(imageUrls: imageUrls, centeredImage: 0)
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
                        MessageImageExpandedView(imageUrls: imageUrls, centeredImage: 1)
                    } label: {
                        KFImage(URL(string: imageUrls[1]))
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25 - 0.25)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                        
                        
                    Spacer()
                    
                    NavigationLink {
                        MessageImageExpandedView(imageUrls: imageUrls, centeredImage: 2)
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
                        MessageImageExpandedView(imageUrls: imageUrls, centeredImage: 0)
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
                        MessageImageExpandedView(imageUrls: imageUrls, centeredImage: 1)
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
                        MessageImageExpandedView(imageUrls: imageUrls, centeredImage: 2)
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
                        MessageImageExpandedView(imageUrls: imageUrls, centeredImage: 3)
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

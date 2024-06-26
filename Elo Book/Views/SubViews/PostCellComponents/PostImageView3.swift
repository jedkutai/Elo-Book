//
//  PostImageView3.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/7/24.
//

import SwiftUI
import Kingfisher

struct PostImageView3: View {
    @Binding var user: User
    @Binding var viewedUser: User
    @Binding var post: Post
    
    @State private var fullLength = false
    @State private var target = 0
    
    
    private let imageWidth = UIScreen.main.bounds.width * 0.85
    var body: some View {
        Group {
            if let imageUrls = post.imageUrls {
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
        
    }

    var one: some View {
        NavigationStack {
            if let imageUrls = post.imageUrls {
                Button {
                    target = 0
                    fullLength.toggle()
                } label: {
                    if fullLength {
                        FullLengthPostImageView(fullLength: $fullLength, target: $target, imageUrls: imageUrls)
                            .padding(.horizontal, 8)
                        
                    } else {
                        KFImage(URL(string: imageUrls[0]))
                            .placeholder {
                                Image("elo_book_app_icon5")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageWidth, height: imageWidth * 0.5 + 5)
                                    .padding(.horizontal, 8)
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageWidth, height: imageWidth * 0.5 + 5)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.horizontal, 8)
                    }
                }
                
            }
        }
            
    }
    
    var two: some View {
        NavigationStack {
            if let imageUrls = post.imageUrls {
                if fullLength {
                    Button {
                        fullLength.toggle()
                        target = 0
                    } label: {
                        FullLengthPostImageView(fullLength: $fullLength, target: $target, imageUrls: imageUrls)
                            .padding(.horizontal, 8)
                    }
                } else {
                    HStack {
                        Button {
                            target = 0
                            fullLength.toggle()
                        } label: {
                            KFImage(URL(string: imageUrls[0]))
                                .placeholder {
                                    Image("elo_book_app_icon5")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: imageWidth * 0.5 - 0.5, height: imageWidth * 0.5 + 5)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.leading, 8)
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: imageWidth * 0.5 - 0.5, height: imageWidth * 0.5 + 5)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.leading, 8)
                        }
                            
                        
                        Spacer()
                        
                        Button {
                            target = 1
                            fullLength.toggle()
                        } label: {
                            KFImage(URL(string: imageUrls[1]))
                                .placeholder {
                                    Image("elo_book_app_icon5")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: imageWidth * 0.5 - 0.5, height: imageWidth * 0.5 + 5)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.trailing, 8)
                                    
                                }
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
        }
    }
    
    var three: some View {
        NavigationStack {
            if let imageUrls = post.imageUrls {
                if fullLength {
                    Button {
                        fullLength.toggle()
                        target = 0
                    } label: {
                        FullLengthPostImageView(fullLength: $fullLength, target: $target, imageUrls: imageUrls)
                            .padding(.horizontal, 8)
                    }
                } else {
                    HStack {
                        Button {
                            target = 0
                            fullLength.toggle()
                        } label: {
                            KFImage(URL(string: imageUrls[0]))
                                .placeholder {
                                    Image("elo_book_app_icon5")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.5 + 5)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.leading, 8)
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.5 + 5)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.leading, 8)
                        }
                            
                        
                        Spacer()
                        
                        VStack {
                            Button {
                                target = 1
                                fullLength.toggle()
                            } label: {
                                KFImage(URL(string: imageUrls[1]))
                                    .placeholder {
                                        Image("elo_book_app_icon5")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25 - 0.25)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25 - 0.25)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                                
                                
                            Spacer()
                            
                            Button {
                                target = 2
                                fullLength.toggle()
                            } label: {
                                KFImage(URL(string: imageUrls[2]))
                                    .placeholder {
                                        Image("elo_book_app_icon5")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25 - 0.25)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
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
        }
    }
    
    var four: some View {
        NavigationStack {
            if let imageUrls = post.imageUrls {
                if fullLength {
                    Button {
                        fullLength.toggle()
                        target = 0
                    } label: {
                        FullLengthPostImageView(fullLength: $fullLength, target: $target, imageUrls: imageUrls)
                            .padding(.horizontal, 8)
                    }
                } else {
                    VStack {
                        HStack {
                            Button {
                                target = 0
                                fullLength.toggle()
                            } label: {
                                KFImage(URL(string: imageUrls[0]))
                                    .placeholder {
                                        Image("elo_book_app_icon5")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(.leading, 8)
                                    }
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.leading, 8)
                            }
                                
                            
                            Spacer()
                            
                            Button {
                                target = 1
                                fullLength.toggle()
                            } label: {
                                KFImage(URL(string: imageUrls[1]))
                                    .placeholder {
                                        Image("elo_book_app_icon5")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(.trailing, 8)
                                    }
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
                                target = 2
                                fullLength.toggle()
                            } label: {
                                KFImage(URL(string: imageUrls[2]))
                                    .placeholder {
                                        Image("elo_book_app_icon5")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(.leading, 8)
                                    }
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.leading, 8)
                            }
                            
                            Spacer()
                            
                            Button {
                                target = 3
                                fullLength.toggle()
                            } label: {
                                KFImage(URL(string: imageUrls[3]))
                                    .placeholder {
                                        Image("elo_book_app_icon5")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(.trailing, 8)
                                        
                                    }
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
    }
}

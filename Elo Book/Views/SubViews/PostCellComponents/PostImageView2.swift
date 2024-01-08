//
//  PostImageView2.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/7/24.
//

//import SwiftUI
//import Kingfisher
//
//struct PostImageView2: View {
//    @Binding var user: User
//    @Binding var viewedUser: User
//    @Binding var post: Post
//    
//    private let imageWidth = UIScreen.main.bounds.width * 0.85
//    var body: some View {
//        Group {
//            if let imageUrls = post.imageUrls {
//                if imageUrls.count == 1 {
//                    one
//                } else if imageUrls.count == 2 {
//                    two
//                } else if imageUrls.count == 3 {
//                    three
//                } else if imageUrls.count == 4 {
//                    four
//                }
//            }
//        }
//        
//    }
//
//    var one: some View {
//        NavigationStack {
//            if let imageUrls = post.imageUrls {
//                NavigationLink {
//                    PostImageExpandedView2(user: $user, viewedUser: $viewedUser, post: $post, centeredImage: 0).navigationBarBackButtonHidden()
//                } label: {
//                    KFImage(URL(string: imageUrls[0]))
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: imageWidth, height: imageWidth * 0.5 + 5)
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                        .padding(.horizontal, 8)
//                }
//            }
//        }
//            
//    }
//
//    var two: some View {
//        NavigationStack {
//            if let imageUrls = post.imageUrls {
//                HStack {
//                    NavigationLink {
//                        PostImageExpandedView2(user: $user, viewedUser: $viewedUser, post: $post, centeredImage: 0)
//                            .navigationBarBackButtonHidden()
//                    } label: {
//                        KFImage(URL(string: imageUrls[0]))
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: imageWidth * 0.5 - 0.5, height: imageWidth * 0.5 + 5)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .padding(.leading, 8)
//                    }
//                        
//                    
//                    Spacer()
//                    
//                    NavigationLink {
//                        PostImageExpandedView2(user: $user, viewedUser: $viewedUser, post: $post, centeredImage: 1)
//                            .navigationBarBackButtonHidden()
//                    } label: {
//                        KFImage(URL(string: imageUrls[1]))
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: imageWidth * 0.5 - 0.5, height: imageWidth * 0.5 + 5)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .padding(.trailing, 8)
//                    }
//                        
//                }
//                .frame(width: imageWidth)
//            }
//        }
//    }
//    
//    var three: some View {
//        NavigationStack {
//            if let imageUrls = post.imageUrls {
//                HStack {
//                    NavigationLink {
//                        PostImageExpandedView2(user: $user, viewedUser: $viewedUser, post: $post, centeredImage: 0)
//                            .navigationBarBackButtonHidden()
//                    } label: {
//                        KFImage(URL(string: imageUrls[0]))
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.5 + 5)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .padding(.leading, 8)
//                    }
//                        
//                    
//                    Spacer()
//                    
//                    VStack {
//                        NavigationLink {
//                            PostImageExpandedView2(user: $user, viewedUser: $viewedUser, post: $post, centeredImage: 1)
//                                .navigationBarBackButtonHidden()
//                        } label: {
//                            KFImage(URL(string: imageUrls[1]))
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25 - 0.25)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                        }
//                            
//                            
//                        Spacer()
//                        
//                        NavigationLink {
//                            PostImageExpandedView2(user: $user, viewedUser: $viewedUser, post: $post, centeredImage: 2)
//                                .navigationBarBackButtonHidden()
//                        } label: {
//                            KFImage(URL(string: imageUrls[2]))
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25 - 0.25)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                        }
//                            
//                    }
//                    .frame(height: imageWidth * 0.5 + 5)
//                    .padding(.trailing, 8)
//                }
//            }
//        }
//    }
//    
//    var four: some View {
//        NavigationStack {
//            if let imageUrls = post.imageUrls {
//                VStack {
//                    HStack {
//                        NavigationLink {
//                            PostImageExpandedView2(user: $user, viewedUser: $viewedUser, post: $post, centeredImage: 0)
//                                .navigationBarBackButtonHidden()
//                        } label: {
//                            KFImage(URL(string: imageUrls[0]))
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                .padding(.leading, 8)
//                        }
//                            
//                        
//                        Spacer()
//                        
//                        NavigationLink {
//                            PostImageExpandedView2(user: $user, viewedUser: $viewedUser, post: $post, centeredImage: 1)
//                                .navigationBarBackButtonHidden()
//                        } label: {
//                            KFImage(URL(string: imageUrls[1]))
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                .padding(.trailing, 8)
//                        }
//                            
//                    }
//                    .frame(width: imageWidth)
//                    .padding(.bottom, 5)
//                    
//                    HStack {
//                        NavigationLink {
//                            PostImageExpandedView2(user: $user, viewedUser: $viewedUser, post: $post, centeredImage: 2)
//                                .navigationBarBackButtonHidden()
//                        } label: {
//                            KFImage(URL(string: imageUrls[2]))
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                .padding(.leading, 8)
//                        }
//                            
//                        
//                        Spacer()
//                        
//                        NavigationLink {
//                            PostImageExpandedView2(user: $user, viewedUser: $viewedUser, post: $post, centeredImage: 3)
//                                .navigationBarBackButtonHidden()
//                        } label: {
//                            KFImage(URL(string: imageUrls[3]))
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: imageWidth * 0.5 - 2.5, height: imageWidth * 0.25)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                .padding(.trailing, 8)
//                        }
//                            
//                    }
//                    .frame(width: imageWidth)
//                }
//            }
//        }
//    }
//}

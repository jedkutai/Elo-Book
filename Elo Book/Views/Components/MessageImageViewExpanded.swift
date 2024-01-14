//
//  MessageImageViewExpanded.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/13/24.
//

import SwiftUI
import Kingfisher

struct MessageImageViewExpanded: View {
    
    @State var imageUrls: [String]
    @State var centeredImage: Int
    
    
    var body: some View {
        VStack {
            Spacer()
            
            ScrollViewReader { value in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(imageUrls, id: \.self) { imageUrl in
                            ScrollView(.vertical) {
                                KFImage(URL(string: imageUrl))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width)
                                    
                            }
                            .id(imageUrls.firstIndex(of: imageUrl))
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .onAppear {
                    value.scrollTo(centeredImage)
                }
            }
            
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    
    }
}


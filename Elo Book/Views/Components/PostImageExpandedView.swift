//
//  PostImageExpandedView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

import SwiftUI
import Kingfisher

struct PostImageExpandedView: View {
    
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

#Preview {
    PostImageExpandedView(imageUrls: [], centeredImage: 0)
}

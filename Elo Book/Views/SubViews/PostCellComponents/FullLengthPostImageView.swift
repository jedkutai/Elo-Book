//
//  FullLengthPostImageView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/7/24.
//

import SwiftUI
import Kingfisher

struct FullLengthPostImageView: View {
    @Binding var fullLength: Bool
    @Binding var target: Int
    let imageUrls: [String]
    private let imageWidth = UIScreen.main.bounds.width * 0.85
    var body: some View {
        ScrollViewReader { value in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(Array(imageUrls.enumerated()), id: \.element ) { index, imageUrl in
                        KFImage(URL(string: imageUrl))
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageWidth)
                            .id(index)
                            .onTapGesture {
                                target = 0
                                fullLength.toggle()
                            }

                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .onAppear {
                value.scrollTo(target)
            }
        }
    }
}


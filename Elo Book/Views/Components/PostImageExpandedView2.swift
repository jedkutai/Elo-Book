//
//  PostImageExpandedView2.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/7/24.
//

import SwiftUI
import Kingfisher

struct PostImageExpandedView2: View {
    @Binding var user: User
    @Binding var viewedUser: User
    @Binding var post: Post
    @State var centeredImage: Int
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if let imageUrls = post.imageUrls {
                        
                        TabView(selection: $centeredImage) {
                            ForEach(Array(imageUrls.enumerated()), id: \.element) { index, imageUrl in
                                PostImageExpandedCell(imageUrl: imageUrl)
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                }
                
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.down.left.topright.rectangle.fill")
                                .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                        }
                        
                        
                        Spacer()
                    }
                    
                    Spacer()
                    Text("bottom text")
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                }
                .padding(.horizontal)
                
            }
        }
    }
}

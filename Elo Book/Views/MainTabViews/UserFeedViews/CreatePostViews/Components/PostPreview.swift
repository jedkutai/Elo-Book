//
//  PostPreview.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/6/24.
//

import SwiftUI
import PhotosUI
import UIKit

struct PostPreview: View {
    @Binding var user: User
    @Binding var caption: String
    @Binding var selectedEvents: [Event]
    @ObservedObject var viewModel: UploadPost
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if !selectedEvents.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(selectedEvents, id: \.id) { event in
                        MiniEventCell(event: event)
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 2.5)
                                    .stroke(Color(.systemGray), lineWidth: 1)
                            )
                            .padding(.leading)
                            
                    }
                }
            }
            .frame(height: 35)
            
        }
        
        VStack {
            
            HStack {
                HStack {
                    SquareProfilePicture(user: user, size: .xSmall)
                    
                    if let fullname = user.fullname {
                        Text("\(fullname)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    }
                    
                    if let username = user.username {
                        Text("\(username)")
                            .font(.footnote)
                            .foregroundColor(Color(.systemGray))
                    }
                }
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.85)
            .padding(.horizontal, 8)
            
            // Body Text
            Group {
                if caption.count > 200 {
                    Text("\(String(caption.prefix(125)))")
                        .font(.subheadline)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        
                    Text("...")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                } else {
                    HStack {
                        Text(caption)
                            .font(.subheadline)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                }
            }
            
            // Body photos
            PostPreviewImages(viewModel: viewModel)
            
            // footer
            HStack(spacing: 8) {
                Spacer()
                
                Image(systemName: "square.stack.3d.up")
                    .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                
                Spacer()
                
                Image(systemName: "bubble")
                    .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                
                Spacer()

                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                
                Spacer()
                
                
                Text("Now")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                
            }
            .padding(.top, 5)
            .padding(.horizontal, 8.0)
            
        }
        .padding(10)
        .frame(width: UIScreen.main.bounds.width - 20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(.gray).opacity(0.5), lineWidth: 2)
        )
    }
}

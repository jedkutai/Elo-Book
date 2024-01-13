//
//  SquareGroupChatPicture.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import SwiftUI
import Kingfisher


struct SquareGroupChatPicture: View {
    
    let thread: Thread
    let size: ProfileImageSize
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if let imageUrl = thread.imageUrl {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFit()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(RoundedRectangle(cornerRadius: size.dimension / 8))
                .overlay(
                    RoundedRectangle(cornerRadius: size.dimension / 8)
                        .stroke(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor, lineWidth: size.dimension / 8 * 0.3)
                )

        } else {
            Image(systemName: "person.3.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size.dimension, height: size.dimension)
                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                .overlay(
                    RoundedRectangle(cornerRadius: size.dimension / 8)
                        .stroke(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor, lineWidth: size.dimension / 8 * 0.3)
                )
        }
        
    }
}

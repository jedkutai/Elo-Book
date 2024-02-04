//
//  CommunityProfilePicture.swift
//  Elo Book
//
//  Created by Jed Kutai on 2/3/24.
//

import SwiftUI
import Kingfisher

struct CommunityProfilePicture: View {
    let community: Community
    let size: ProfileImageSize
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if let imageUrl = community.imageUrl {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFit()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(RoundedRectangle(cornerRadius: size.dimension / 8))
                .overlay(
                    RoundedRectangle(cornerRadius: size.dimension / 8)
                        .stroke(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor, lineWidth: size.dimension / 8 * 0.3)
                )
                .padding(1)

        } else {
            Image(systemName: "rectangle.3.group")
                .resizable()
                .scaledToFit()
                .padding(2.5)
                .frame(width: size.dimension, height: size.dimension)
                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                .overlay(
                    RoundedRectangle(cornerRadius: size.dimension / 8)
                        .stroke(Color(.systemGray), lineWidth: size.dimension / 8 * 0.3)
                )
                .padding(1)
        }
    }
}

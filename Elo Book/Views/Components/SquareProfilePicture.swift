//
//  SquareProfilePicture.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI
import Kingfisher

enum ProfileImageSize {
    case xxSmall
    case xSmall
    case small
    case shmedium
    case medium
    case large
    case xxLarge
    
    var dimension: CGFloat {
        switch self {
        case .xxSmall:
            return 10
        case .xSmall:
            return 20
        case .small:
            return 32
        case .shmedium:
            return 40
        case .medium:
            return 64
        case .large:
            return 80
        case .xxLarge:
            return 120
        }
    }
}

struct SquareProfilePicture: View {
    
    let user: User
    let size: ProfileImageSize
    
    var body: some View {
        if let profileImageUrl = user.profileImageUrl {
            KFImage(URL(string: profileImageUrl))
                .resizable()
                .scaledToFit()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(RoundedRectangle(cornerRadius: size.dimension / 8)) // Adjust the corner radius as needed
                .overlay(
                    RoundedRectangle(cornerRadius: size.dimension / 8) // Same corner radius as above
                        .stroke(Color.gray, lineWidth: size.dimension / 8 * 0.3) // Customize border color and width
                )

        } else {
            Image(systemName: "person.crop.square.fill")
                .resizable()
                .frame(width: size.dimension, height: size.dimension)
                .clipped()
                .foregroundColor(Color(.systemGray4))
        }
        
    }
}

#Preview {
    SquareProfilePicture(user: User.MOCK_USER, size: .small)
}

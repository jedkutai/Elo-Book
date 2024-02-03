//
//  CommunityCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 2/3/24.
//

import SwiftUI
import Kingfisher

struct CommunityCell: View {
    @State var community: Community
    
    @State private var communityFounder: User?
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            // commmunity image
            CommunityProfilePicture(community: community, size: .shmedium)
            VStack(spacing: 0) {
                // community name pushed left
                HStack {
                    Text(community.communityDisplayName)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                
                // founder
                if let communityFounder = communityFounder {
                    HStack {
                        // username
                        if let username = communityFounder.username {
                            Text("Founder: \(username)")
                                .foregroundStyle(Color(.systemGray))
                                .font(.footnote)
                            
                            // badge
                            if let badge = communityFounder.displayedBadge {
                                BadgeDisplayer(badge: badge)
                            }
                        }
                        
                        Spacer()
                    }
                    
                }
            }
            
            Spacer()
            
            HStack {
                Label("\(community.memberCount)", systemImage: "person.3.sequence")
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                
            }
        }
        .onAppear {
            Task {
                do {
                    communityFounder = try await FetchService.fetchUserById(withUid: community.ownerId)
                }
            }
        }
    }
}



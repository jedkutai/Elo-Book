//
//  UserResultCell.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI

struct UserResultCell: View {
    @State var user: User
    
    @EnvironmentObject var x: X
    @State private var hidden = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if self.hidden {
            
        } else {
            HStack {
                SquareProfilePicture(user: user, size: .shmedium)
                
                VStack {
                    if let fullname = user.fullname {
                        HStack {
                            Text(fullname)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            
                            Spacer()
                        }
                    }
                    
                    if let username = user.username {
                        HStack {
                            Text("@\(username)")
                                .font(.footnote)
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            
                            if let displayedBadge = user.displayedBadge {
                                BadgeDisplayer(badge: displayedBadge)
                            }
                            
                            Spacer()
                        }
                    }
                    
                }
                
                Spacer()
            }
            .padding(.horizontal, 10)
            .onAppear {
                let blockedByUser = x.blockedBy.contains { block in
                    return block.userId == user.id
                }
                
                let blockedUser = x.blocked.contains { block in
                    return block.userToBlockId == user.id
                }
                
                self.hidden = blockedByUser || blockedUser
            }
        }
        
    }
}

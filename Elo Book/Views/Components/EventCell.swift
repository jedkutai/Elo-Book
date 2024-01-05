//
//  EventCell.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI
import Kingfisher

struct EventCell: View {
    @State var event: Event
    
    @State private var team1: Team?
    @State private var team2: Team?
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            HStack {
                Group {
                    if let team = team1 {
                        KFImage(URL(string: team.teamLogo))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                }
                .padding(.leading, 30)
                
                Spacer()
                
                VStack {
                    Text(event.title)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    
                    Text("\(DateFormatter.longDate(timestamp: event.timestamp))")
                        .font(.footnote)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                }
                
                Spacer()
                
                Group {
                    if let team = team2 {
                        KFImage(URL(string: team.teamLogo))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                }
                .padding(.trailing, 30)
            }
            .onAppear {
                Task {
                    team1 = try await FetchService.fetchTeamById(docId: event.team1_ID)
                    team2 = try await FetchService.fetchTeamById(docId: event.team2_ID)
                }
            }
        }
    }
}

//
//  EventsHorizontalScroll.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI

struct EventsHorizontalScroll: View {
    @Binding var user: User
    @State var events: [Event]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(events, id: \.id) { event in
                    NavigationLink {
                        EventView(user: user, event: event).navigationBarBackButtonHidden()
                    } label: {
                        MiniEventCell(event: event)
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 2.5)
                                    .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
        }
        .frame(height: 35)
        .padding(.horizontal)
    }
}

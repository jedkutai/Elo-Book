//
//  ContactAccountsDisplayer.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/15/24.
//

import SwiftUI
import Contacts


struct ContactAccountsDisplayer: View {
    @State var contact: CNContact
    @Binding var user: User
    
    @State private var canShow: Bool = false
    @State private var accounts: [User]?
    
    private let linkToApp = "Come join the good guys. https://www.elobook.org"
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("\(contact.givenName) \(contact.familyName)")
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        .fontWeight(.bold)
                        .font(.title3)
                    
                    Spacer()
                }
                
                if let accounts = accounts {
                    ForEach(accounts, id: \.id) { account in
                        HStack {
                            NavigationLink {
                                AltUserProfileView(user: user, viewedUser: account)
                            } label: {
                                UserResultCell(user: account)
                            }
                            
                            Spacer()
                        }
                    }
                } else {
                    if canShow {
                        HStack {
                            ShareLink(item: linkToApp) {
                                Label("Invite \(contact.givenName)", systemImage: "person.badge.plus")
                                    .foregroundColor(Color(.systemBlue))
                            }
                            
                            Spacer()
                        }
                        .padding(.leading)
                    } else {
                        ProgressView("Searching...")
                    }
                }
            }
            .padding(.horizontal)
            .onAppear {
                Task {
                    let accountsFound = try await FetchService.fetchAccountsByContact(contact: contact)
                    if !accountsFound.isEmpty {
                        accounts = accountsFound
                    }
                    canShow = true
                }
            }
        }
    }
}

//
//  SelectCommunityName.swift
//  Elo Book
//
//  Created by Jed Kutai on 2/2/24.
//

import SwiftUI

struct SelectCommunityName: View {
    @State var user: User
    
    @State private var communityName: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                
                Image(systemName: "rectangle.3.group")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .foregroundStyle(Color(.systemGray))
                
                TextField("Name", text: $communityName)
                    .modifier(IGTextFieldModifier())
                
            }
            .navigationTitle("Community Name")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .onSubmit {
                hideKeyboard()
            }
        }
    }
}

//#Preview {
//    SelectCommunityName()
//}

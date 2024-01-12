//
//  CreateNewMessageViewHeader.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/12/24.
//

import SwiftUI

struct CreateNewMessageViewHeader: View {
    
    var dismiss: DismissAction
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Text("Cancel")
                    .font(.footnote)
                    .foregroundStyle(Color(.systemRed))
            }
            Spacer()
            
            Text("NEW MESSAGE")
                .fontWeight(.bold)
                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            
            Spacer()
            
            Text("Cancel")
                .font(.footnote)
                .foregroundStyle(Color(.clear))
            
        }
        .padding(.horizontal)
        .padding(.top)
    }
}


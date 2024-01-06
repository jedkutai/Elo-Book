//
//  SettingsOption.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/25/23.
//

import SwiftUI

struct SettingsOption: View {
    @State var systemName: String
    @State var text: String
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            Image(systemName: "\(systemName)")
                .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
            Text("\(text)")
                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color(.systemGray))
        }
        .padding(.top, 10)
        
    }
}

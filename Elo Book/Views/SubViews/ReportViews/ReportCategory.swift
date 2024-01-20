//
//  ReportCategory.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/18/24.
//

import SwiftUI

struct ReportCategory: View {
    @Binding var toggle: Bool
    @Binding var submitting: Bool
    @State var toggleName: String
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Button {
            if !submitting {
                toggle.toggle()
            }
        } label: {
            HStack {
                
                if submitting {
                    Text("\(toggleName)")
                        .foregroundStyle(Color(.systemGray))
                    
                    Spacer()
                    
                    if toggle {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color(.systemGray))
                    } else {
                        Image(systemName: "circle")
                            .foregroundStyle(Color(.systemGray))
                    }
                } else {
                    Text("\(toggleName)")
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    
                    Spacer()
                    
                    if toggle {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color(.systemGreen))
                    } else {
                        Image(systemName: "circle")
                            .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                    }
                }
            }
            .padding(.top, 10)
            .padding(.horizontal)
            
        }
    }
}

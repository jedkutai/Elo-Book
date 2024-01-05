//
//  HideKeyboard.swift
//  Elo
//
//  Created by Jed Kutai on 12/16/23.
//

import SwiftUI

struct HideKeyboard: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

#Preview {
    HideKeyboard()
}

//
//  ResestPasswordExitCover.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/15/24.
//

import SwiftUI

struct ResestPasswordExitCover: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("If the email is in our system, you will receive a reset link.")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .foregroundStyle(Color(.systemGray))
                
                NavigationLink {
                    LoginControllerView().navigationBarBackButtonHidden()
                } label: {
                    Text("Continue")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 360, height: 44)
                        .background(Color(.systemBlue))
                        .cornerRadius(8)
                        .padding(.top, 20)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ResestPasswordExitCover()
}

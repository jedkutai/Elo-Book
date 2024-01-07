//
//  ProgressWheel.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/6/24.
//

import SwiftUI

struct ProgressWheel: View {
    let characterCount: Int
    let maxCharacterCount: Int

    var body: some View {
        let progress = min(Double(characterCount) / Double(maxCharacterCount), 1.0)

        if Double(characterCount) / Double(maxCharacterCount) < 0.75 {
            return Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(Color.blue, lineWidth: 5)
                .frame(width: 20, height: 20)
                .rotationEffect(.degrees(-90))
        } else if Double(characterCount) / Double(maxCharacterCount) < 1.0 {
            return Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(Color.orange, lineWidth: 5)
                .frame(width: 20, height: 20)
                .rotationEffect(.degrees(-90))
        } else {
            return Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(Color.red, lineWidth: 5)
                .frame(width: 20, height: 20)
                .rotationEffect(.degrees(-90))
        }
    }
}


//
//  PegView.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 4/16/25.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    let backgroundColor: Color

    // MARK: - Body

    let pegShape = Circle()

    var body: some View {
        pegShape
            .stroke()
            .background(
                Circle().foregroundStyle(backgroundColor)
            )
            .overlay { Text(peg).font(.title2) }
    }
}

#Preview {
    PegView(peg: "Q", backgroundColor: Color.yellow)
        .padding()
}

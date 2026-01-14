//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 4/30/25.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeWordBreaker

    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name).font(.title)

            if let lastAttempt = game.attempts.last {
                CodeWithMatchMarkersView(code: lastAttempt)
            } else {
                CodeWithMatchMarkersView(
                    code: Code(kind: .unknown, size: game.masterCode.pegs.count)
                )
            }

            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
    }
}

#Preview {
    List {
        GameSummary(game: CodeWordBreaker(name: "Preview"))
    }
}

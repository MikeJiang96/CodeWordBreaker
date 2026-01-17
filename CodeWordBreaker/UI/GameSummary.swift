//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 4/30/25.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeWordBreaker

    static let lastAttemptPreviewMaxHeight: CGFloat = 30

    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name).font(.title)

            if let lastAttempt = game.attempts.last {
                CodeBasicView(code: lastAttempt)
                    .frame(maxHeight: GameSummary.lastAttemptPreviewMaxHeight)
            } else {
                CodeBasicView(
                    code: Code(
                        kind: .unknown,
                        pegs: Array(repeating: Code.missingPeg, count: game.masterCode.pegs.count)
                    )
                )
                .frame(maxHeight: GameSummary.lastAttemptPreviewMaxHeight)
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

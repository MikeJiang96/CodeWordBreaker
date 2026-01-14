//
//  CodeWithMarkersView.swift
//  CodeWordBreaker
//
//  Created by Mike Jiang on 2026/1/14.
//

import SwiftUI

struct CodeWithMatchMarkersView: View {
    // MARK: Data In
    let code: Code

    // MARK: - Body

    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(
                    peg: code.pegs[index],
                    backgroundColor: CodeWithMatchMarkersView.calcPegBackgroundColor(for: code, at: index)
                )
            }
        }
    }

    static func calcPegBackgroundColor(for code: Code, at index: Int) -> Color {
        var color = Code.pegNoMatchColor

        if index < code.matches.count {
            if code.matches[index] == .exact {
                color = Code.pegExactMatchColor
            } else if code.matches[index] == .inexact {
                color = Code.pegInexactMatchColor
            }
        }

        return color.opacity(0.5)
    }
}

#Preview {
    CodeWithMatchMarkersView(
        code: {
            let game = CodeWordBreaker(masterCode: "GUESS")
            game.guess.word = "GGUGS"
            game.attemptGuess()
            return game.attempts.last ?? Code(kind: .unknown, size: 5)
        }()
    )
}

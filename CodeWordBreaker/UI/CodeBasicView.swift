//
//  CodeBasicView.swift
//  CodeWordBreaker
//
//  Created by Mike Jiang on 2026/1/14.
//

import SwiftUI

struct CodeBasicView<AugmentedPegView: View>: View {
    typealias AugmentPegViewFunc = (PegView, Int) -> AugmentedPegView

    // MARK: Data In
    let code: Code
    let augmentPegViewFunc: AugmentPegViewFunc

    init(
        code: Code,
        @ViewBuilder augmentPegViewFunc: @escaping AugmentPegViewFunc
    ) {
        self.code = code
        self.augmentPegViewFunc = augmentPegViewFunc
    }

    init(code: Code) where AugmentedPegView == PegView {
        self.code = code
        self.augmentPegViewFunc = { pegView, _ in pegView }
    }

    // MARK: - Body

    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                let pegView = PegView(
                    peg: code.pegs[index],
                    backgroundColor: CodeBasicView.calcPegBackgroundColor(for: code, at: index)
                )

                augmentPegViewFunc(pegView, index)
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
    CodeBasicView(
        code: {
            let game = CodeWordBreaker(masterCode: "GUESS")
            game.guess.word = "GSGGS"
            game.attemptGuess()
            return game.attempts.last ?? Code(kind: .unknown, size: 5)
        }()
    )

    CodeBasicView(
        code: {
            let game = CodeWordBreaker(masterCode: "GUESS")
            game.guess.word = "GGUGS"
            game.attemptGuess()
            return game.attempts.last ?? Code(kind: .unknown, size: 5)
        }()
    ) { pegView, _ in
        return pegView.onTapGesture {
            print("\(pegView.peg)")
        }
    }
}

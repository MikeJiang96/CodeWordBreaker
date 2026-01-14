//
//  Code.swift
//  CodeWordBreaker
//
//  Created by Mike Jiang on 2026/1/13.
//

import Foundation

enum Match {
    case nomatch
    case exact
    case inexact
}

struct Code: Hashable {
    var kind: Kind
    var pegs: [Peg]

    static let missingPeg: Peg = ""

    var word: String {
        get { pegs.joined() }
        set { pegs = newValue.map { String($0) } }
    }

    enum Kind: Equatable, Hashable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }

    init(kind: Kind, size: Int) {
        self.kind = kind
        pegs = Array(repeating: Code.missingPeg, count: size)
    }

    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
        }
    }

    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): return isHidden
        default: return false
        }
    }

    var matches: [Match] {
        switch kind {
        case .attempt(let matches):
            return matches
        default: return []
        }
    }

    func match(against otherCode: Code) -> [Match] {
        var results: [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs

        for index in pegs.indices.reversed() {
            if index < pegsToMatch.count && pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }

        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }

        return results
    }
}

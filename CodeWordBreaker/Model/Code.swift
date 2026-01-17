//
//  Code.swift
//  CodeWordBreaker
//
//  Created by Mike Jiang on 2026/1/13.
//

import Foundation
import SwiftData

enum Match: String {
    case nomatch
    case exact
    case inexact
}

@Model
class Code {
    var _kind: String = Kind.unknown.description
    var _pegs: String = ""
    var timestamp = Date.now

    // Must one char's size
    static let missingPeg: Peg = " "

    var pegs: [Peg] {
        get {
            _pegs.map { String($0) }
        }
        set {
            _pegs = newValue.joined()
        }
    }

    var word: String {
        get { _pegs }
        set { _pegs = newValue }
    }

    var kind: Kind {
        get { return Kind(_kind) }
        set { _kind = newValue.description }
    }

    init(kind: Kind, pegs: [Peg]) {
        self.kind = kind
        self.pegs = pegs
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

//
//  Trivia.swift
//  Jocelyn-Boyd-TandemFor400
//
//  Created by Jocelyn Boyd on 10/27/20.
//

import Foundation

enum JSONError: Error {
    case decodingError(Error)
}

struct TriviaModel: Codable {
    let question: String
    let incorrect: [String]
    let correct: String
    
    func fetchPossibleAnswers() -> [String] {
        var shuffleAnswers = incorrect
        shuffleAnswers.append(correct)
        return shuffleAnswers.shuffled()
    }
    
    static func fetchTrivia(from data: Data) throws -> [TriviaModel] {
        do {
            let trivia = try JSONDecoder().decode([TriviaModel].self, from: data)
            return trivia
        } catch {
            throw JSONError.decodingError(error)
        }
    }
}

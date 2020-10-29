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

struct Trivia: Codable {
    let question: String
    let incorrectAnswers: [String]
    let correctAnswer: String
    
    private enum CodingKeys: String, CodingKey {
        case question
        case incorrectAnswers = "incorrect"
        case correctAnswer = "correct"
    }
    
    public func fetchPossibleAnswers() -> [String] {
        var shuffleAnswers = incorrectAnswers
        shuffleAnswers.append(correctAnswer)
        return shuffleAnswers.shuffled()
    }
    
    static func fetchTrivia(from data: Data) throws -> [Trivia] {
        do {
            let trivia = try JSONDecoder().decode([Trivia].self, from: data)
            return trivia
        } catch {
            throw JSONError.decodingError(error)
        }
    }
}

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
    let incorrect: [String]
    let correct: String
    
    static func fetchTrivia(from data: Data) throws -> Trivia {
        do {
            let trivia = try JSONDecoder().decode(Trivia.self, from: data)
            return trivia
        } catch {
            throw JSONError.decodingError(error)
        }
    }
}

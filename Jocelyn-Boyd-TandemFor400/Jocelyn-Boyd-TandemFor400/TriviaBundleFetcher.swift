//
//  TriviaNetworkManager.swift
//  Jocelyn-Boyd-TandemFor400
//
//  Created by Jocelyn Boyd on 10/29/20.
//

import Foundation

class TriviaBundleFetcher {
    
    // add loadTriviaDataFromJSON() from TriviaViewControllers
    static let manager = TriviaBundleFetcher()
    private init() {}
    
    func loadTriviaDataFromBundle(completionHandler: @escaping (Result<[Trivia],Error>) -> Void) {
        
        guard let pathToData = Bundle.main.path(forResource: "Apprentice_TandemFor400_Data", ofType: "json") else {
            fatalError("Apprentice_TandemFor400_Data.json not found")
        }
        let interalURL = URL(fileURLWithPath: pathToData)
        do {
            let data = try Data(contentsOf: interalURL)
            let triviaInfo = try Trivia.loadTriviaFromJSON(from: data).shuffled()
            completionHandler(.success(triviaInfo))
        } catch {
            fatalError("Failed to get data.")
        }
    }
}

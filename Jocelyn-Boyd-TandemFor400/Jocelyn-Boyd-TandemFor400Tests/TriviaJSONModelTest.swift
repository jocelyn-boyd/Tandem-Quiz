//
//  TriviaJSONModelTest.swift
//  Jocelyn-Boyd-TandemFor400Tests
//
//  Created by Jocelyn Boyd on 10/27/20.
//

import XCTest
@testable import Jocelyn_Boyd_TandemFor400

class TriviaJSONModelTest: XCTestCase {
    
    private func getTriviaFromJSONData() -> Data {
        guard let pathToData = Bundle.main.path(forResource: "Apprentice_TandemFor400_Data", ofType: "json") else {
            fatalError("Apprentice_TandemFor400_Data.json file not found")
        }
        let internalURL = URL(fileURLWithPath: pathToData)
        
        do {
            let data = try Data(contentsOf: internalURL)
            return data
        } catch {
            fatalError("An error occured: \(error)")
        }
    }
    
    func testLoadTriviaData() {
        let triviaData = getTriviaFromJSONData()
        do {
            _ = try Trivia.fetchTrivia(from: triviaData)
        } catch {
            print(error)
        }
        XCTAssertNotNil(triviaData)
    }
}

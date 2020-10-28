//
//  TrivaScreenVC.swift
//  Jocelyn-Boyd-TandemFor400
//
//  Created by Jocelyn Boyd on 10/27/20.
//

import UIKit

class TrivaScreenVC: UIViewController {

    @IBOutlet var triviaProgressBar: UIProgressView!
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var optionOne: UIButton!
    @IBOutlet var optionTwo: UIButton!
    @IBOutlet var optionThree: UIButton!
    @IBOutlet var optionFour: UIButton!
    
    var triviaInfo: [Trivia]?
    var currentQuestionIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTriviaDataFromJSON()
        let question = triviaInfo?[currentQuestionIndex]
        questionLabel.text = question?.question
    }
    
    private func loadTriviaDataFromJSON() {
        guard let pathToData = Bundle.main.path(forResource: "Apprentice_TandemFor400_Data", ofType: "json") else {
            fatalError("Apprentice_TandemFor400_Data.json not found")
        }
        let interalURL = URL(fileURLWithPath: pathToData)
        do {
            let data = try Data(contentsOf: interalURL)
            let triviaFromJSON = try Trivia.fetchTrivia(from: data)
            triviaInfo = triviaFromJSON
            dump(triviaInfo)
        } catch {
            print(error)
        }
    }
    
    @IBAction func showNextQuestion(_ sender: Any) {
        currentQuestionIndex += 1
        if currentQuestionIndex == triviaInfo?.count {
            currentQuestionIndex = 0
        }
        let question = triviaInfo?[currentQuestionIndex]
        questionLabel.text = question?.question
    }
}

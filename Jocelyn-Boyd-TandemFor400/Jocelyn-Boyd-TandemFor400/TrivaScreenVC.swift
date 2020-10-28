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
    @IBOutlet var questionCounterLabel: UILabel!
    
    @IBOutlet var buttonOne: UIButton!
    @IBOutlet var buttonTwo: UIButton!
    @IBOutlet var buttonThree: UIButton!
    @IBOutlet var buttonFour: UIButton!
    
    var triviaInfo: [Trivia]?
    var currentQuestionIndex: Int = 0
    var maxQuestionsInOneRound: Int = 11
    var maxQuesitonsInRoundTwo: Int = 21
    var score: Int = 0
    var triviaProgressStart: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTriviaDataFromJSON()
        updateQuestion()
    }
        
    @IBAction private func answerPressed(_ sender: UIButton) {
        
        if currentQuestionIndex < maxQuestionsInOneRound || currentQuestionIndex < maxQuesitonsInRoundTwo {
            
            let question = triviaInfo?[currentQuestionIndex]
            if sender.titleLabel?.text == question?.correct {
                score += 1
                let alert = UIAlertController(title: "Correct!", message: "Way to go!", preferredStyle: .alert)
                let nextQuestionAction = UIAlertAction(title: "Next", style: .default, handler: nil)
                alert.addAction(nextQuestionAction)
                present(alert, animated: true) { self.updateQuestion() }
            } else {
                let alert = UIAlertController(title: "Sorry!", message: "The correct answer is: \(question!.correct)", preferredStyle: .alert)
                let nextQuestionAction = UIAlertAction(title: "Next", style: .default, handler: nil)
                alert.addAction(nextQuestionAction)
                present(alert, animated: true) { self.updateQuestion() }
            }
            
        } else {
            currentQuestionIndex = 12
        }
    }
    
    private func presentEndOfGameAlert() {
        let alert = UIAlertController(title: "End of Round One", message: "Ready for Round Two?", preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Next", style: .default, handler: nil)
        alert.addAction(restartAction)
        present(alert, animated: true) {
            self.currentQuestionIndex = 11
            self.updateQuestion()
        }
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
        } catch {
            print(error)
        }
    }
    
    private func updateQuestion() {
        let question = triviaInfo?[currentQuestionIndex]
        questionLabel.text = question?.question
        
        let shuffledAnswers = question?.shuffledAnswers()
        if shuffledAnswers?.count == 4 {
            buttonOne.setTitle(shuffledAnswers?[0], for: .normal)
            buttonTwo.setTitle(shuffledAnswers?[1], for: .normal)
            buttonThree.setTitle(shuffledAnswers?[2], for: .normal)
            buttonFour.isHidden = false
            buttonFour.setTitle(shuffledAnswers?[3], for: .normal)
        } else if shuffledAnswers?.count == 3{
            buttonOne.setTitle(shuffledAnswers?[0], for: .normal)
            buttonTwo.setTitle(shuffledAnswers?[1], for: .normal)
            buttonThree.setTitle(shuffledAnswers?[2], for: .normal)
            buttonFour.isHidden = true
        } else {
            buttonOne.setTitle(shuffledAnswers?[0], for: .normal)
            buttonTwo.setTitle(shuffledAnswers?[1], for: .normal)
            buttonThree.setTitle(shuffledAnswers?[2], for: .normal)
            buttonFour.isHidden = false
            buttonFour.setTitle(shuffledAnswers?[3], for: .normal)
        }
        currentQuestionIndex += 1
        updateUI()
    }
    
    private func updateUI() {
        let questionNumber = currentQuestionIndex
        questionCounterLabel.text? = "\(questionNumber.description) / \(maxQuestionsInOneRound)"
        triviaProgressBar.progress += 0.2
    }
    
    private func restartQuiz() {
        score = 0
        currentQuestionIndex = 0
        updateQuestion()
    }
}

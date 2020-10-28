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
    @IBOutlet var restartButton: UIButton!
    
    var triviaInfo: [TriviaModel]?
    var currentQuestionIndex: Int = 0
    var score: Int = 0
    var triviaProgressStart: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTriviaDataFromJSON()
        configureButtons()
        showNextQuestion()
    }
    
    @IBAction private func answerButtonPressed(_ sender: UIButton) {
        let question = triviaInfo?[currentQuestionIndex - 1]
        if sender.titleLabel?.text == question?.correct {
            score += 1
            let alert = UIAlertController(title: "Correct!", message: "Way to go!", preferredStyle: .alert)
            let nextQuestionAction = UIAlertAction(title: "Next Question", style: .default) { (_) in
                self.showNextQuestion()
            }
            alert.addAction(nextQuestionAction)
            present(alert, animated: true) { self.score += 1 }
        } else {
            let alert = UIAlertController(title: "Sorry!", message: "The correct answer is: \(question!.correct).", preferredStyle: .alert)
            let nextQuestionAction = UIAlertAction(title: "Next Question", style: .default) { (_) in
                self.showNextQuestion()
            }
            alert.addAction(nextQuestionAction)
            present(alert, animated: true)
        }
    }
    
    @IBAction func restartButtonPressed(_ sender: UIButton) {
        score = 0
        currentQuestionIndex = 0
        showNextQuestion()
        enableMultipleChoiceButtons()
        updateGameStatusBar()
    }
    
    private func loadTriviaDataFromJSON() {
        guard let pathToData = Bundle.main.path(forResource: "Apprentice_TandemFor400_Data", ofType: "json") else {
            fatalError("Apprentice_TandemFor400_Data.json not found")
        }
        let interalURL = URL(fileURLWithPath: pathToData)
        do {
            let data = try Data(contentsOf: interalURL)
            let triviaFromJSON = try TriviaModel.fetchTrivia(from: data)
            triviaInfo = triviaFromJSON
        } catch {
            print(error)
        }
    }
    
    private func showNextQuestion() {
        restartButton.isHidden = true
        let question = triviaInfo?[currentQuestionIndex]
        questionLabel.text = question?.question
        
        let shuffledAnswers = question?.shuffledAnswers()
        if shuffledAnswers?.count == 4 {
            buttonOne.setTitle(shuffledAnswers?[0], for: .normal)
            buttonTwo.setTitle(shuffledAnswers?[1], for: .normal)
            buttonThree.setTitle(shuffledAnswers?[2], for: .normal)
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
        updateTriviaScreen()
    }
    
    private func updateTriviaScreen() {
        if currentQuestionIndex != 5 { // change to 20
            currentQuestionIndex += 1
            updateGameStatusBar()
        } else {
            restartButton.isHidden = false
            questionLabel.text = "End of Quiz. You scored \(score) / 5 correct!" // change to XX/20
            disableMultupleChoiceButtonsButtons()
        }
    }
    
    private func updateGameStatusBar() {
        let questionNumber = currentQuestionIndex
        questionCounterLabel.text? = "\(questionNumber)/10 Questions"
        triviaProgressBar.progress = Float(questionNumber) / 5 // change to 20
    }
    
    private func enableMultipleChoiceButtons() {
        let buttons = [buttonOne, buttonTwo, buttonThree, buttonFour]
        for button in buttons {
            button?.isHidden = false
        }
    }
    
    private func disableMultupleChoiceButtonsButtons() {
        let buttons = [buttonOne, buttonTwo, buttonThree, buttonFour]
        for button in buttons {
            button?.isHidden = true
        }
    }
    
    private func configureButtons() {
        let buttons = [buttonOne, buttonTwo, buttonThree, buttonFour]
        for button in buttons {
            button?.layer.cornerRadius = 20
            button?.backgroundColor = UIColor(red: 17 / 255, green: 138 / 255, blue: 178 / 255, alpha: 1)
        }
        restartButton.backgroundColor = .systemRed
        restartButton.layer.cornerRadius = 10
    }
}

//
//  TrivaScreenVC.swift
//  Jocelyn-Boyd-TandemFor400
//
//  Created by Jocelyn Boyd on 10/27/20.
//
import UIKit

class TrivaScreenVC: UIViewController {
    
    @IBOutlet private var triviaProgressBar: UIProgressView!
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var questionCounterLabel: UILabel!
    @IBOutlet private var buttonOne: UIButton!
    @IBOutlet private var buttonTwo: UIButton!
    @IBOutlet private var buttonThree: UIButton!
    @IBOutlet private var buttonFour: UIButton!
    @IBOutlet private var restartButton: UIButton!
    
    private var buttons = [UIButton]()
    private var triviaInfo = [Trivia]()
    private var currentQuestionIndex: Int = 0
    private var score: Int = 0
    private var triviaProgressStart: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        loadTriviaDataFromJSON()
        loadNewQuestion()
    }
    
    @IBAction private func answerButtonPressed(_ sender: UIButton) {
        let question = triviaInfo[currentQuestionIndex - 1]
        if sender.titleLabel?.text == question.correctAnswer {
            showAlert(title: "Correct!", message: "Way to go!") {
                self.loadNewQuestion()
                self.score += 1
            }
        } else {
            showAlert(title: "Sorry", message: "The correct answer is: \(question.correctAnswer)") {
                self.loadNewQuestion()
            }
        }
    }
    
    @IBAction private func restartButtonPressed(_ sender: UIButton) {
        score = 0
        currentQuestionIndex = 0
        loadNewQuestion()
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
            let triviaFromJSON = try Trivia.fetchTrivia(from: data)
            triviaInfo = triviaFromJSON.shuffled()
        } catch {
            fatalError("Failed to get data.")
        }
    }
    
    private func loadNewQuestion() {
        restartButton.isHidden = true
        let question = triviaInfo[currentQuestionIndex]
        questionLabel.text = question.question
        
        let shuffledAnswers = question.fetchPossibleAnswers()
        buttons = [buttonOne, buttonTwo, buttonThree, buttonFour]
        buttons.forEach {$0.isHidden = true}
        
        for (index, answer) in shuffledAnswers.enumerated() {
            buttons[index].isHidden = false
            buttons[index].setTitle(answer, for: .normal)
        }
        updateTriviaScreen()
    }
    
    private func updateTriviaScreen() {
        if currentQuestionIndex != 10 {
            currentQuestionIndex += 1
            updateGameStatusBar()
        } else {
            restartButton.isHidden = false
            questionLabel.text = "You scored \(score) / 10 correct!"
            disableMultupleChoiceButtonsButtons()
        }
    }
    
    private func updateGameStatusBar() {
        let questionNumber = currentQuestionIndex
        questionCounterLabel.text? = "\(questionNumber) / 10 Questions"
        triviaProgressBar.progress = Float(questionNumber) / 10
    }
    
    private func enableMultipleChoiceButtons() {
        let buttons = [buttonOne, buttonTwo, buttonThree, buttonFour].compactMap { $0 }
        for button in buttons {
            button.isHidden = false
        }
        self.buttons = buttons
    }
    
    private func disableMultupleChoiceButtonsButtons() {
        let buttons = [buttonOne, buttonTwo, buttonThree, buttonFour].compactMap { $0 }
        for button in buttons {
            button.isHidden = true
        }
        self.buttons = buttons
    }
    
    private func configureButtons() {
        let buttons = [buttonOne, buttonTwo, buttonThree, buttonFour].compactMap { $0 }
        for button in buttons {
            button.layer.cornerRadius = 20
            button.backgroundColor = UIColor(red: 17 / 255, green: 138 / 255, blue: 178 / 255, alpha: 1)
        }
        self.buttons = buttons
        restartButton.backgroundColor = .systemRed
        restartButton.layer.cornerRadius = 10
    }
}

extension UIViewController {
    func showAlert(title: String?, message: String?, action: (() -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let nextQuestionAction = UIAlertAction(title: "Next Question", style: .default) { (_) in
            action?()
        }
        alert.addAction(nextQuestionAction)
        present(alert, animated: true)
    }
}

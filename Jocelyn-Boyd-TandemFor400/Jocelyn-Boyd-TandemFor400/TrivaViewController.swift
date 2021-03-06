//
//  TrivaScreenVC.swift
//  Jocelyn-Boyd-TandemFor400
//
//  Created by Jocelyn Boyd on 10/27/20.
//
import UIKit

class TrivaViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private var triviaProgressBar: UIProgressView!
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var questionCounterLabel: UILabel!
    @IBOutlet private var buttonOne: UIButton!
    @IBOutlet private var buttonTwo: UIButton!
    @IBOutlet private var buttonThree: UIButton!
    @IBOutlet private var buttonFour: UIButton!
    @IBOutlet private var restartButton: UIButton!
    @IBOutlet var gameplayButton: UIButton!
    
    // MARK: - Properties
    private var buttons = [UIButton]()
    private var triviaInfo = [Trivia]()
    private var currentQuestionIndex: Int = 0
    private var score: Int = 0
    private var triviaProgressStart: Float = 0.0
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        loadTriviaDataFromJSON()
        loadNewQuestion()
    }
    
    // MARK: - Actions
    @IBAction private func answerButtonPressed(_ sender: UIButton) {
        // TODO: Remove the alert and change the color of the buttons to reflect if the selected answer was correct or incorrect, refresh the view with a new question after a couple of seconds
        let question = triviaInfo[currentQuestionIndex - 1]
        if sender.titleLabel?.text == question.correctAnswer {
            showAlert(title: "Correct", message: "Way to go!") {
                self.loadNewQuestion()
                self.score += 1
            }
        } else {
            showAlert(title: "Try Again", message: "The correct answer is: \(question.correctAnswer)") {
                self.loadNewQuestion()
            }
        }
    }
    
    @IBAction private func restartButtonPressed(_ sender: UIButton) {
        score = 0
        currentQuestionIndex = 0
        loadTriviaDataFromJSON()
        loadNewQuestion()
        updateProgressBar()
        enableDisableAnswerButtons(isEnabled: true)
    }
    
    // MARK: - Private Methods
    private func loadTriviaDataFromJSON() {
        TriviaBundleFetcher.manager.loadTriviaDataFromBundle { (result) in
            switch result {
            case let .success(trivia):
                self.triviaInfo = trivia
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func loadNewQuestion() {
        restartButton.isHidden = true
        let question = triviaInfo[currentQuestionIndex]
        questionLabel.text = question.question
        
        let shuffledAnswers = question.fetchPossibleAnswers()
        switch shuffledAnswers.count {
        case 4:
            for (index, answer) in shuffledAnswers.enumerated() {
                buttons[index].isHidden = false
                buttons[index].setTitle(answer, for: .normal)
            }
        case 3:
            for (index, answer) in shuffledAnswers.enumerated() {
                buttonFour.isHidden = true
                buttons[index].setTitle(answer, for: .normal)
            }
        default:
            buttons = [buttonOne, buttonTwo, buttonThree, buttonFour]
            buttons.forEach {$0.isHidden = true}
        }
        updateTriviaScreen()
    }
    
    private func updateTriviaScreen() {        
        switch currentQuestionIndex {
        case 10:
            restartButton.isHidden = false
            updateScore()
            enableDisableAnswerButtons(isEnabled: false)
        default:
            currentQuestionIndex += 1
            updateProgressBar()
        }
    }
    
    private func updateScore() {
        switch score {
        case 10:
            questionLabel.text = "Awesome! A perfect 10!"
        case 5...9:
            questionLabel.text = "Pretty Good! You scored \(score) / 10 correct."
        default:
            questionLabel.text = "You almost had it. You scored \(score) / 10 correct."
        }
    }
    
    private func updateProgressBar() {
        let questionNumber = currentQuestionIndex
        questionCounterLabel.text? = "\(questionNumber) / 10 Questions"
        triviaProgressBar.progress = Float(questionNumber) / 10
        triviaProgressBar.progressTintColor = UIColor(red: 17 / 255, green: 138 / 255, blue: 178 / 255, alpha: 1)
        // TODO: Alternate colors on progress bar -> green for correct and red incorrect
    }
    
    private func enableDisableAnswerButtons(isEnabled: Bool) {
        let buttons = [buttonOne, buttonTwo, buttonThree, buttonFour].compactMap { $0 }
        for button in buttons {
            button.isHidden = isEnabled ? false : true
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
        gameplayButton.layer.cornerRadius = 10
        gameplayButton.backgroundColor = UIColor(red: 239/255, green: 71/255, blue: 111/255, alpha: 1)
    }
}

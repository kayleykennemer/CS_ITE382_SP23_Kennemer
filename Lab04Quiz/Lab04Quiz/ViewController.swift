//
//  ViewController.swift
//  Lab04Quiz
//
//  Created by Kayley Kennemer on 2/9/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

var questionLabel : UILabel!
var answerLabel : UILabel!

func showNextQuestion(_ sender: UIButton) {
    currentQuestionIndex += 1
    if currentQuestionIndex == questions.count {
        currentQuestionIndex = 0
    }
    let _: String = questions[currentQuestionIndex]
    questionLabel.text = questions[currentQuestionIndex]
    answerLabel.text = "???"
}
func showAnswer(_ sender: UIButton) {
    let answer: String = answers[currentQuestionIndex]
    answerLabel.text = answer
}

let questions: [String] = [
    "What is 7+7",
    "What is the capital of Vermont?",
    "What is cognac made from?"
]
let answers: [String] = [
    "14",
    "Montpelier",
    "Grapes"
]
var currentQuestionIndex: Int = 0



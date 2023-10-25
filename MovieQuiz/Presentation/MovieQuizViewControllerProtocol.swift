//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Кирилл on 25.10.2023.
//

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showStep(_ step: QuizStepViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func enableButtons()
    func disableButtons()
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

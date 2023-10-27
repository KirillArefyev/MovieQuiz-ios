//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Кирилл on 22.10.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Private Properties
    private let gameStatistic: StatisticServiceProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private let questionsAmount = 10
    private var currentQuizQuestionIndex = 0
    private var userCorrectAnswers = 0
    init(viewController: MovieQuizViewControllerProtocol?) {
        self.viewController = viewController
        self.gameStatistic = StatisticService()
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.alertPresenter = AlertPresenter(delegate: viewController as? UIViewController)
        questionFactory?.loadData()
        viewController?.showLoadingIndicator()
    }
    // MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(_ questionStep: QuizQuestion?) {
        guard let questionStep = questionStep else { return }
        currentQuestion = questionStep
        let viewModel = convert(model: questionStep)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showStep(viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.hideLoadingIndicator()
        showNetworkError(message: error.localizedDescription)
    }
    // MARK: - Methods
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let stepView = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuizQuestionIndex + 1)/\(questionsAmount)")
        return stepView
    }
    
    func noButtonTapped() {
        didAnswer(isYes: false)
    }
    
    func yesButtonTapped() {
        didAnswer(isYes: true)
    }
    // MARK: - Private Methods
    private func answerResult(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            userCorrectAnswers += 1
        }
    }
    
    private func isLastQuestion() -> Bool {
        currentQuizQuestionIndex == questionsAmount - 1
    }
    
    private func switchToNextQuestion() {
        currentQuizQuestionIndex += 1
    }
    
    private func restartGame() {
        currentQuizQuestionIndex = 0
        userCorrectAnswers = 0
        viewController?.showLoadingIndicator()
        questionFactory?.loadData()
        questionFactory?.requestNextQuestion()
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let userAnswer = isYes
        proceedWithAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
    
    private func proceedWithAnswerResult(isCorrect: Bool) {
        answerResult(isCorrectAnswer: isCorrect)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
            self.viewController?.enableButtons()
        }
    }
    
    private func proceedToNextQuestionOrResults() {
        viewController?.showLoadingIndicator()
        if self.isLastQuestion() {
            guard
                let gameStatistic = gameStatistic,
                let bestGame = gameStatistic.bestGame,
                let date = bestGame.date
            else {
                return
            }
            gameStatistic.store(correct: userCorrectAnswers, total: questionsAmount)
            viewController?.hideLoadingIndicator()
            let alertView = AlertModel(
                title: "Этот раунд окончен!",
                message: """
                    Ваш результат: \(userCorrectAnswers)/\(questionsAmount)
                    Количество сыгранных квизов: \(gameStatistic.gamesCount)
                    Рекорд: \(bestGame.correct)/\(bestGame.total) (\(date.dateTimeString))
                    Средняя точность: \(String(format: "%.2f", gameStatistic.totalAccuracy))%
                    """,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] in
                    guard let self = self else { return }
                    self.restartGame()
                })
            alertPresenter?.showResult(alertView)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showNetworkError(message: String) {
        viewController?.hideLoadingIndicator()
        let errorAlertView = AlertModel(
            title: "Что-то пошло не так(",
            message: "Невозможно загрузить данные",
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                guard let self = self else { return }
                self.restartGame()
            })
        alertPresenter?.showResult(errorAlertView)
    }
}

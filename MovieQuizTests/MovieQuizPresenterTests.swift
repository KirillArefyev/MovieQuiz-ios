//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Кирилл on 25.10.2023.
//

import XCTest
@testable import MovieQuiz

final class MoveQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showStep(_ step: MovieQuiz.QuizStepViewModel) {}
    func highlightImageBorder(isCorrectAnswer: Bool) {}
    func enableButtons() {}
    func disableButtons() {}
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MoveQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}

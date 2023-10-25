//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Кирилл on 30.09.2023.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private var movies: [MostPopularMovie] = []
    private let moviesLoader: MoviesLoadingProtocol
    private weak var delegate: QuestionFactoryDelegate?
    init(moviesLoader: MoviesLoadingProtocol, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImage)
            } catch {
                print("Ошибка загрузки изображения")
            }
            let rating = Float(movie.rating ?? "0") ?? 0
            let randomRating = Int.random(in: 6...9)
            let moreOrLess = ["больше", "меньше"]
            let moreOrLessRandom = moreOrLess.randomElement() ?? "больше"
            let text = "Рейтинг этого фильма \(moreOrLessRandom), чем \(randomRating)?"
            let correctAnswer: Bool
            if moreOrLessRandom == "больше" {
                correctAnswer = rating > Float(randomRating)
            } else {
                correctAnswer = rating < Float(randomRating)
            }
            let questionStep = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didRecieveNextQuestion(questionStep)
            }
        }
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}

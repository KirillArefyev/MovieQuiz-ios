//
//  MoviesLoadingProtocol.swift
//  MovieQuiz
//
//  Created by Кирилл on 07.10.2023.
//

import Foundation

protocol MoviesLoadingProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

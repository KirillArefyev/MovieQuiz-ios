//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Кирилл on 07.10.2023.
//

import Foundation

struct MoviesLoader: MoviesLoadingProtocol {
    private let networkClient: NetworkRouting
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    private let apiParts = ["Top250Movies", "MostPopularMovies"]
    private var moviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/\(apiParts.randomElement() ?? "Top250Movies")/k_zcuw1ytf") else {
            preconditionFailure("Невозможно создать moviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: moviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

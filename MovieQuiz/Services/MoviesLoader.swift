//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Travka Andrey on 26.02.2025.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    private enum MoviesLoaderError: Error, LocalizedError {
        case invalidAPIKey(String)
        case noItemsData

        public var errorDescription: String? {
            switch self {
            case .invalidAPIKey(let errorMessage):
                return errorMessage
            case .noItemsData:
                return "No data returned from IMDB API"
            }
        }
    }

    private let networkClient = NetworkClient()

    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    if !mostPopularMovies.errorMessage.isEmpty {
                        handler(.failure(MoviesLoaderError.invalidAPIKey(mostPopularMovies.errorMessage)))
                    }
                    if mostPopularMovies.items.isEmpty {
                        handler(.failure(MoviesLoaderError.noItemsData))
                    }
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

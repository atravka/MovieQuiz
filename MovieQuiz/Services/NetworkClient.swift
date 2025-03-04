//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Travka Andrey on 26.02.2025.
//

import Foundation

struct NetworkClient {

    private enum NetworkError: Error, LocalizedError {
        case codeError(Int)
        public var errorDescription: String? {
            switch self {
            case .codeError(let codeError):
                return "HTTP code error: \(codeError)"
            }
        }
    }

    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url, timeoutInterval: 15)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                return
            }

            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                // при любом коде не равном 200, мы не получим данных для обработки
                // поэтому правильный код ответа только 200, остальное ошибка...
                handler(.failure(NetworkError.codeError(response.statusCode)))
                return
            }

            // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
        }

        task.resume()
    }
}

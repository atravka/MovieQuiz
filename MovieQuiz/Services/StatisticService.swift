//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Travka Andrey on 17.02.2025.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {

    private let storage: UserDefaults = .standard

    // MARK: - Keys for storage
    private enum Keys: String {
        case correct            // всего правильных ответов
        case questions          // всего вопросов
        case gamesCount         // сыграно игр
        case bestGameCorrect    // наибольшее количество правильных ответов в лучшей игре
        case bestGameTotal      // вопросов в лучшей игре
        case bestGameDate       // дата лучшей игры
    }

    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total   = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date    = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
         }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }

    var totalAccuracy: Double {
        // Всего правильных ответов
        let totalCorrect:   Int = storage.integer(forKey: Keys.correct.rawValue)
        // Всего ответов
        let totalQuestions: Int = storage.integer(forKey: Keys.questions.rawValue)
        guard totalQuestions > 0 else {
            return 0.0
        }
        // Итого средняя точность
        return ( Double(totalCorrect) / Double(totalQuestions) ) * 100.0
    }

    func store(correct count: Int, total amount: Int) {
        // Считаем общее количество правильных ответов
        let totalCorrect: Int = count + storage.integer(forKey: Keys.correct.rawValue)
        // Сохраняем общее количество правильных ответов
        storage.set(totalCorrect, forKey: Keys.correct.rawValue)
        // Считаем общее количество заданных вопросов
        let totalQuestions: Int = amount + storage.integer(forKey: Keys.questions.rawValue)
        // Сохраняем общее количество заданных вопросов
        storage.set(totalQuestions, forKey: Keys.questions.rawValue)
        // Сохраняем количество сыгранных игр
        gamesCount += 1
        // Проверяем на лучший результат ...
        let gameResult: GameResult = GameResult(correct: count, total: amount, date: Date())
        // ... и при необходимости обновляем историю игр
        if bestGame.compare(gameResult) {
            bestGame = gameResult
        }
    }
}

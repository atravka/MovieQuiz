//
//  StatisticModel.swift
//  MovieQuiz
//
//  Created by Travka Andrey on 17.02.2025.
//

import Foundation

struct GameResult {
    let correct: Int    // количество правильных ответов
    let total: Int      // количество вопросов квиз
    let date: Date      // дата завершения раунда
    
    func compare(_ thisGame: GameResult) -> Bool {
        // сравнение с учётом количества вопросов в игре,
        // вдруг захотим увеличить или уменьшить количество вопросов
        guard total > 0 else {
            return true
        }
       
        return Double(correct) / Double(total) < Double(thisGame.correct) / Double(thisGame.total)
    }
}

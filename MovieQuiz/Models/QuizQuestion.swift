//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Travka Andrey on 02.02.2025.
//

import Foundation

struct QuizQuestion {
    // строка с названием фильма,
    // совпадает с названием картинки афиши фильма в Assets
    // let image: String
    let image: Data
    // строка с вопросом о рейтинге фильма
    let text: String
    // булевое значение (true, false), правильный ответ на вопрос
    let correctAnswer: Bool
}
    

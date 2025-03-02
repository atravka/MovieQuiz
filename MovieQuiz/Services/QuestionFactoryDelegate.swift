//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Travka Andrey on 05.02.2025.
//

import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}

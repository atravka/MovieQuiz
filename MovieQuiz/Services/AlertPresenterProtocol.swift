//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Travka Andrey on 10.02.2025.
//

import Foundation

protocol AlertPresenterProtocol {
    func show(alertModel: AlertModel)
}

protocol AlertPresenterDelegate {
    func nextRound()
}

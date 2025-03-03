//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Travka Andrey on 08.02.2025.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {

    weak var viewController: (UIViewController&AlertPresenterDelegate)?

    init(viewController: UIViewController&AlertPresenterDelegate) {
        self.viewController = viewController
    }

    func show(alertModel: AlertModel) {
        let uIAlertController = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default) { _ in alertModel.completion() }

        uIAlertController.addAction(action)
        viewController?.present(uIAlertController, animated: true )
    }
}

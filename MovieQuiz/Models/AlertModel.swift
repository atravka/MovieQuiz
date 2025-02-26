//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Travka Andrey on 08.02.2025.
//

import Foundation

struct AlertModel {
    let title:      String         // текст заголовка алерта
    let message:    String        // текст сообщения алерта
    let buttonText: String       // текст для кнопки алерта
    var completion: () -> Void  // замыкание без параметров для действия по кнопке алерта:
}

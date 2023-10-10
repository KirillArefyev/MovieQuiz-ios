//
//  ErrorAlertPresenter.swift
//  MovieQuiz
//
//  Created by Кирилл on 05.10.2023.
//

import UIKit

final class ErrorAlertPresenter: ErrorAlertProtocol {
    private weak var delegate: UIViewController?
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    
    func showErrorAlert(_ errorAlert: AlertModel) {
        let alert = UIAlertController(
            title: errorAlert.title,
            message: errorAlert.message,
            preferredStyle: .alert)
        let alertAction = UIAlertAction(
            title: errorAlert.buttonText,
            style: .default) { _ in
                errorAlert.completion()
            }
        alert.addAction(alertAction)
        delegate?.present(alert, animated: true, completion: nil)
    }
}

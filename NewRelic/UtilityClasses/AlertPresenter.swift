//
//  AlertPresenter.swift
//  NewRelic
//
//  Copyright © 2022 newrelicchallenge. All rights reserved.
//

import UIKit

protocol AlertPresenter: AnyObject { }

extension AlertPresenter where Self: UIViewController {

    func showSimpleAlertWithNoTitle(message: String, buttonTitle: String,
                                    cancelButton: Bool? = false, completion: (() -> Swift.Void)? = nil) {

        let alertController = UIAlertController(
            title: "",
            message: message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(
            title: buttonTitle,
            style: .default,
            handler: { _ in completion?() }
        )
        alertController.addAction(action)

        if let cancelButton = cancelButton, cancelButton == true {
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )
            alertController.addAction(cancelAction)
        }

        self.present(alertController, animated: true, completion: nil)
    }

}

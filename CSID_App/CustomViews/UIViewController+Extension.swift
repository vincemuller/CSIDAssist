//
//  UIViewController+Extension.swift
//  CSID_App
//
//  Created by Vince Muller on 12/18/23.
//

import UIKit

extension UIViewController {
    
    func presentGFAlertOnMain(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = CSIDAlertVC(title: title, message: message, button: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func presentAppUpdateNotification(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = UpdateNotificationVC(title: title, message: message, button: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}

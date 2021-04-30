//
//  String+Validation.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/7/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import UIKit

extension Date {
    func isValidBirthdate(minAge: Int = 13) -> Bool {
        return self >= Calendar.current.date(byAdding: .year, value: -minAge, to: Date()) ?? Date()
    }
}

extension String {

    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let predicate  = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }

    func isValidPassword(min: Int = 8, max: Int = 24) -> Bool {
        let emailRegex = "([:print:]){\(min),\(max)}"
        let predicate  = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }

    func isValidUrl() -> Bool {
        if let url = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }

    func urlForm() -> URL? {
        if isValidUrl() {
            return URL(string: self)
        } else {
            let fullUrl = "http://" + self
            if fullUrl.isValidUrl() {
                return URL(string: fullUrl)
            }
        }

        return nil
    }
}

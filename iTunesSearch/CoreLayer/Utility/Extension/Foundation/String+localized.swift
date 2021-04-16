//
//  String+localized.swift
//  KakacoCommerce
//
//  Created by 한상진 on 2021/04/09.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: Bundle.main,
            value: self,
            comment: ""
        )
    }
}

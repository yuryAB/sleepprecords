//
//  String+Extension.swift
//  sleepprecords
//
//  Created by yury antony on 27/05/25.
//
import Foundation

extension String {
    var localized: String {
        return Bundle.main.localizedString(forKey: self, value: nil, table: nil)
    }
}

//
//  String+Extension.swift
//  REM
//
//  Created by yury antony on 27/05/25.
//
import Foundation

extension String {
    var localizable: String {
        return Bundle.main.localizedString(forKey: self, value: nil, table: nil)
    }
}

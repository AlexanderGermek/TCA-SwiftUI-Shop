//
//  Formatter+Numeric.swift
//  ComposableTest
//
//  Created by GERMEK Aleksandr on 17.01.2024.
//

import Foundation

extension Formatter {
	static let withSeparator: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.groupingSeparator = " "
		return formatter
	}()

	static let withCommaSeparator: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.groupingSeparator = " "
		formatter.decimalSeparator = ","
		return formatter
	}()
}

extension Numeric {
	var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
	var formatWithCommaSeparator: String { Formatter.withCommaSeparator.string(for: self) ?? "" }
}

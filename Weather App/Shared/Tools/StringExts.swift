//
//  StringExts.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 08.02.21.
//

import Foundation

extension String {
	func substring(with r: Range<Int>) -> String {
		let startIndex = self.startIndex
		let L = self.index(startIndex, offsetBy: r.lowerBound)
		let R = self.index(startIndex, offsetBy: r.upperBound)
		return String(self[L..<R])
	}
}

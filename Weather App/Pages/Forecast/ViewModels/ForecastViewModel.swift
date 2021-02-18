//
//  ForecastViewModel.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 08.02.21.
//

import Foundation

struct ForecastViewModel {

	private let _date: UInt64
	private let _dateText: String
	private let _description: String
	private let _iconName: String
	private let _temperature: Int

	init(
		date: UInt64,
		dateText: String,
		description: String,
		iconName: String,
		temperature: Int
	) {
		self._date = date
		self._dateText = dateText
		self._description = description
		self._iconName = iconName
		self._temperature = temperature
	}

	var timeFrom1970: UInt64 {
		return _date
	}

	var date: String {
		return _dateText.components(separatedBy: [" "])[0]
	}

	var hour: String {
		return _dateText.components(separatedBy: [" "])[1].substring(with: 0..<5)
	}

	var description: String {
		return _description
	}

	var iconName: String {
		return _iconName
	}

	var temperature: String {
		return "\(_temperature - 273)ºC"
	}
}

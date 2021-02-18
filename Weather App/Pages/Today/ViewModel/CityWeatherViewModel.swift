//
//  CityWeatherViewModel.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 07.02.21.
//

import Foundation

struct CityWeatherViewModel {

	private let _city: String
	private let _countryCode: String
	private let _iconName: String
	private let _temperature: Double
	private let _mainDescription: String
	private let _cloudiness: Int
	private let _humidity: Int
	private let _windSpeed: Double
	private let _windDirection: Int

	init(
		city: String,
		countryCode: String,
		iconName: String,
		temperature: Double,
		mainDescription: String,
		cloudiness: Int,
		humidity: Int,
		windSpeed: Double,
		windDirection: Int
	) {
		_city = city
		_countryCode = countryCode
		_iconName = iconName
		_temperature = temperature
		_mainDescription = mainDescription
		_cloudiness = cloudiness
		_humidity = humidity
		_windSpeed = windSpeed
		_windDirection = windDirection
	}


	public var city: String {
		return _city
	}

	public var countryCode: String {
		return _countryCode
	}

	public var iconName: String {
		return _iconName
	}

	public var temperature: String {
		return (Int(round(_temperature - 273))).description + "°C"
	}

	public var mainDescription: String {
		return "\(temperature) | \(_mainDescription)"
	}

	public var cloudiness: Int {
		return _cloudiness
	}

	public var humidity: String {
		return "\(_humidity) mm"
	}

	public var windSpeed: String {
		return "\(_windSpeed) km/h"
	}

	public var windDirection: String {
		let realDirectionGradus = (_windDirection + 360) % 360
		let direction = Int(realDirectionGradus / (360 / CityWeatherViewModel.directions.count))
		return CityWeatherViewModel.directions[direction]
	}

	public var locationDescription: String {
		return "\(city), \(countryCode)"
	}

	private static let directions = [ "N", "NW", "W", "SW", "S", "SE", "E", "NE" ]
}

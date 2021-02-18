//
//  CityWeatherViewModelFactory.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 07.02.21.
//

import Foundation

class CityWeatherViewModelFactory {

	static func create(fromResponse response: TodayWeatherResponse) -> CityWeatherViewModel {

		return CityWeatherViewModel(
			city: response.name,
			countryCode: response.sys.country,
			iconName: response.weather.first!.icon,
			temperature: response.main.temp,
			mainDescription: response.weather.first!.main,
			cloudiness: response.clouds.all,
			humidity: response.main.humidity,
			windSpeed: response.wind.speed,
			windDirection: response.wind.deg
		)
	}

}

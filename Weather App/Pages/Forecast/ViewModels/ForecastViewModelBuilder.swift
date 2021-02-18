//
//  ForecastViewModelBuilder.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 08.02.21.
//

import Foundation

class ForecastViewModelBuilder {

	public static func build(from item: ForecastItem) -> ForecastViewModel {
		return ForecastViewModel(
			date: item.dt,
			dateText: item.dt_txt,
			description: item.weather.first!.description,
			iconName: item.weather.first!.icon,
			temperature: (Int(item.main.temp))
		)
	}

}

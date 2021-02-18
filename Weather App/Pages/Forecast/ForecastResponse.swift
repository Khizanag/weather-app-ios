//
//  ForecastResponse.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 08.02.21.
//

import Foundation

struct ForecastResponse: Codable {
	let cod: String
	let message: Int
	let cnt: Int
	let list: [ForecastItem]
	let city: CityInfo
}

struct ForecastItem: Codable {
	let dt: UInt64
	let main: MainInfo
	let weather: [WeatherInfoItem]
	let clouds: CloudInfo
	let wind: WindInfo
	let visibility: Int
	let pop: Double
//	let rain: RainInfo
//	let snow: SnowInfo
	let sys: SysInfo
	let dt_txt: String
	
}

struct SnowInfo: Codable {
	let volumeForLastThreeHours: Double

	enum CodingKeys: String, CodingKey {
		case volumeForLastThreeHours = "3h"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		volumeForLastThreeHours = try container.decode(Double.self, forKey: .volumeForLastThreeHours)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(volumeForLastThreeHours, forKey: .volumeForLastThreeHours)
	}
}

struct RainInfo: Codable {
	let volumeForLastThreeHours: Double

	enum CodingKeys: String, CodingKey {
		case volumeForLastThreeHours = "3h"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		volumeForLastThreeHours = try container.decode(Double.self, forKey: .volumeForLastThreeHours)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(volumeForLastThreeHours, forKey: .volumeForLastThreeHours)
	}
}

struct MainInfo: Codable {
	let temp: Double
	let feels_like: Double
	let temp_min: Double
	let temp_max: Double
	let pressure: Int
	let sea_level: Int
	let grnd_level: Int
	let humidity: Int
	let temp_kf: Double
}

struct WeatherInfoItem: Codable {
	let id: Int
	let main: String
	let description: String
	let icon: String
}

struct CloudInfo: Codable {
	let all: Int
}

struct WindInfo: Codable {
	let speed: Double
	let deg: Int
}

struct SysInfo: Codable {
	let pod: String
}

struct CityInfo: Codable {
	let id: Int
	let name: String
	let coord: Coordinate
	let country: String
	let population: UInt64
	let timezone: Int
	let sunrise: UInt64
	let sunset: UInt64
}

//
//  OpenWeatherMapEntities.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 07.02.21.
//

import Foundation

struct TodayWeatherResponse: Codable {
	let coord: Coordinate
	let weather: [WeatherItem]
	let base: String
	let main: Main
	let visibility: Int
	let wind: Wind
	let clouds: Clouds
	let dt: UInt64
	let sys: Sys
	let timezone: Int
	let id: Int
	let name: String
	let cod: UInt64
}

struct Coordinate: Codable {
	let lon: Double
	let lat: Double
}

struct WeatherItem: Codable {
	let id: Int
	let main: String
	let description: String
	let icon: String // TODO
}

struct Main: Codable {
	let temp: Double
	let feels_like: Double
	let temp_min: Double
	let temp_max: Double
	let pressure: Int
	let humidity: Int
}

struct Wind: Codable {
	let speed: Double
	let deg: Int
}

struct Clouds: Codable {
	let all: Int
}

struct Sys: Codable {
	let type: Int
	let id: Int
	let country: String
	let sunrise: UInt64
	let sunset: UInt64
}



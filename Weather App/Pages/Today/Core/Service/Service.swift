//
//  Service.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 06.02.21.
//

import Foundation

enum ServiceType {
	case Weather
	case Forecast
}

class Service {

	private var components = URLComponents()
	private let mode: ServiceType

	init(type: ServiceType) {
		components.scheme = "https"
		components.host =  "api.openweathermap.org"

		switch type {
			case .Weather:
				components.path = "/data/2.5/weather"
				mode = .Weather
			case .Forecast:
				components.path = "/data/2.5/forecast"
				mode = .Forecast
		}
	}

	func loadTodayData(forCity city: String, completion: @escaping (Result<TodayWeatherResponse, Error>) -> ()) {
		
		let parameters = [
			"appid": Constants.apiKey,
			"q": city
		]

		components.queryItems = parameters.map { key, value in
			return URLQueryItem(name: key, value: value)
		}

		if let url = components.url {

			let request = URLRequest(url: url)
			let task = URLSession.shared.dataTask( with: request, completionHandler: { data, response, error in

					if let error = error {
						print("Error: \(error)")
						completion(.failure(ServiceError.notCompleted))
					}

					if let data = data {
						let decoder = JSONDecoder()
						do {
							let result: TodayWeatherResponse = try decoder.decode(TodayWeatherResponse.self, from: data)
							completion(.success(result))
						} catch {
							completion(.failure(ServiceError.cantDecode))
						}
					} else {
						completion(.failure(ServiceError.noData))
					}
			})
			task.resume()
		}
	}

	public func loadTodayData(forLocation location: (Double, Double), completion: @escaping (Result<TodayWeatherResponse, Error>) -> ()) {

		let parameters = [
			"lat": location.0.description,
			"lon": location.1.description,
			"appid": Constants.apiKey
		]

		components.queryItems = parameters.map { key, value in
			return URLQueryItem(name: key, value: value)
		}

		if let url = components.url {

			let request = URLRequest(url: url)
			let task = URLSession.shared.dataTask( with: request, completionHandler: { data, response, error in

					if let error = error {
						print("Error: \(error)")
						completion(.failure(ServiceError.notCompleted))
					}

					if let data = data {
						let decoder = JSONDecoder()
						do {
							let result: TodayWeatherResponse = try decoder.decode(TodayWeatherResponse.self, from: data)
							completion(.success(result))
						} catch {
							completion(.failure(ServiceError.cantDecode))
						}
					} else {
						completion(.failure(ServiceError.noData))
					}
			})
			task.resume()
		}
	}

	private func loadTodayData(url urlString: String, completion: @escaping (Result<TodayWeatherResponse, Error>) -> ()) {
		let _url = URL(string: urlString)
		guard let url = _url else { return }

		let request = URLRequest(url: url)
		let task = URLSession.shared.dataTask( with: request, completionHandler: { data, response, error in

				if let error = error {
					print("Error: \(error)")
					completion(.failure(ServiceError.notCompleted))
				}

				if let data = data {
					let decoder = JSONDecoder()
					do {
						let result: TodayWeatherResponse = try decoder.decode(TodayWeatherResponse.self, from: data)
						completion(.success(result))
					} catch {
						completion(.failure(ServiceError.cantDecode))
					}
				} else {
					completion(.failure(ServiceError.noData))
				}
		})
		task.resume()
	}

	public func requestForecast(for city: String, completion: @escaping (Result<ForecastResponse, Error>) -> ()) {
		guard mode == .Forecast else { return }

		let parameters = [
			"q" : city,
			"appid" : Constants.apiKey,
		]

		components.queryItems = parameters.map { key, value in
			return URLQueryItem(name: key, value: value)
		}

		if let url = components.url {
			print("-- Service.requestForecast with url: \(url)")
			let request = URLRequest(url: url)
			let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
				if let error = error {
					completion(.failure(error))
				}

				if let data = data {
					let decoder = JSONDecoder()
					do {
						let result: ForecastResponse = try decoder.decode(ForecastResponse.self, from: data)
						completion(.success(result))
					} catch {
						completion(.failure(ServiceError.cantDecode))
					}
				} else {
					completion(.failure(ServiceError.noData))
				}

			})

			task.resume()
		}
	}

}

enum ServiceError: Error {
	case notCompleted
	case noData
	case cantDecode
}

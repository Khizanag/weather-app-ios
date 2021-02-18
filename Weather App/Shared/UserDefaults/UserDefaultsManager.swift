//
//  UserDefaultsManager.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 28.01.21.
//

import Foundation

class UserDefaultsManager {

	public static let shared = UserDefaultsManager()

	private let userDefaults = UserDefaults.standard

	private init() {}

	public func deleteCity(at index: Int) {
		let citiesArray = userDefaults.array(forKey: UserDefaultKeys.citiesArray)
		if let citiesArray = citiesArray as? [String] {
			var citiesMutableArray = citiesArray
			citiesMutableArray.remove(at: index)
			userDefaults.setValue(citiesMutableArray, forKey: UserDefaultKeys.citiesArray)
		}
	}

	public func insertCity(_ city: String) {
		let citiesArray = userDefaults.array(forKey: UserDefaultKeys.citiesArray)
		if let citiesArray = citiesArray as? [String] {
			var citiesMutableArray = citiesArray
			citiesMutableArray.append(city)
			userDefaults.setValue(citiesMutableArray, forKey: UserDefaultKeys.citiesArray)
		}
	}

	public func isFirstRun() -> Bool {
		return userDefaults.object(forKey: UserDefaultKeys.isFirstRun) == nil
	}
}

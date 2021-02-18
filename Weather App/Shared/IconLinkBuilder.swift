//
//  IconLinkBuilder.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 08.02.21.
//

import Foundation

class IconPathBuilder {

	static func build(for iconName: String) -> String {
		return "https://openweathermap.org/img/wn/\(iconName)@2x.png"
	}
	
}

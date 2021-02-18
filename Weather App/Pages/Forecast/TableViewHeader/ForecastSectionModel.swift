//
//  ForecastSectionModel.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 08.02.21.
//

import Foundation

struct ForecastSectionModel {

	public var headerModel: ForecastSectionHeaderModel
	public var rowModels: [ForecastViewModel]

	init(
		headerModel: ForecastSectionHeaderModel,
		rowModels: [ForecastViewModel]
	) {
		self.headerModel = headerModel
		self.rowModels = rowModels
	}

}

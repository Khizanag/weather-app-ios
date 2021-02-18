//
//  TodayWeatherInfoLine.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 27.01.21.
//

import Foundation
import UIKit

struct TodayWeatherInfoLineModel {

	public var icon: UIImage
	public var description: String
	public var info: String

	init(icon: UIImage, description: String, info: String) {
		self.icon = icon
		self.description = description
		self.info = info
	}

}

class TodayWeatherInfoLine: BaseReusableView {
	
	@IBOutlet weak var iconView: UIImageView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var infoLabel: UILabel!

	private var model: TodayWeatherInfoLineModel?

	public func configure(with model: TodayWeatherInfoLineModel) {
		self.model = model
		self.iconView.image = model.icon
		self.descriptionLabel.text = model.description
		self.infoLabel.text = model.info
	}
	
}

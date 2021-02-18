//
//  TodayCarouselViewCell.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 26.01.21.
//

import Alamofire
import AlamofireImage
import UIKit
import ScalingCarousel
import SDWebImage
import CollectionViewPagingLayout

class TodayCarouselViewCell: ScalingCarouselCell {

	static let identifier = "TodayCarouselViewCell"

	@IBOutlet weak var icon: UIImageView!
	@IBOutlet weak var locationDescriptionLabel: UILabel!
	@IBOutlet weak var mainDescription: UILabel!

	@IBOutlet weak var cloudinessRow: TodayWeatherInfoLine!
	@IBOutlet weak var humidityRow: TodayWeatherInfoLine!
	@IBOutlet weak var windSpeedRow: TodayWeatherInfoLine!
	@IBOutlet weak var windDirectionRow: TodayWeatherInfoLine!

	private var model: CityWeatherViewModel!

	override func layoutSubviews() {
		super.layoutSubviews()
	}

	public func configure(model: CityWeatherViewModel, color: UIColor) {
		self.model = model

		mainView.backgroundColor = color


		icon.sd_setImage(
			with: URL(string: IconPathBuilder.build(for: model.iconName)),
			placeholderImage: UIImage(named: Constants.IconNames.defaultIconName))

		let iconToSet = UIImage(named: model.iconName)
		if let iconToSet = iconToSet {
			icon.image = iconToSet
		}
		locationDescriptionLabel.text = model.locationDescription

		mainDescription.text = model.mainDescription

		configureRows()

		setNeedsLayout()
		layoutIfNeeded()
	}

	private func configureRows() {
		configureCloudiness()
		configureHumidity()
		configureWindSpeed()
		configureWindDirection()
	}

	private func configureCloudiness() {
		let _cloudinessIcon = UIImage(named: Constants.IconNames.cloudiness)
		let cloudinessIcon = _cloudinessIcon ?? UIImage(named: Constants.IconNames.defaultIconName)!
		let cloudinessRowModel = TodayWeatherInfoLineModel(
			icon: cloudinessIcon,
			description: "Cloudiness",
			info: model.cloudiness.description
		)
		cloudinessRow.configure(with: cloudinessRowModel)
	}

	private func configureHumidity() {
		let _icon = UIImage(named: Constants.IconNames.humidity)
		let icon = _icon ?? UIImage(named: Constants.IconNames.defaultIconName)!
		let rowModel = TodayWeatherInfoLineModel(
			icon: icon,
			description: "Humidity",
			info: model.humidity
		)
		humidityRow.configure(with: rowModel)
	}

	private func configureWindSpeed() {
		let _icon = UIImage(named: Constants.IconNames.windSpeed)
		let icon = _icon ?? UIImage(named: Constants.IconNames.defaultIconName)!
		let rowModel = TodayWeatherInfoLineModel(
			icon: icon,
			description: "Wind Speed",
			info: model.windSpeed
		)
		windSpeedRow.configure(with: rowModel)
	}

	private func configureWindDirection() {
		let _icon = UIImage(named: Constants.IconNames.windDirection)
		let icon = _icon ?? UIImage(named: Constants.IconNames.defaultIconName)!
		let rowModel = TodayWeatherInfoLineModel(
			icon: icon,
			description: "Wind Direction",
			info: model.windDirection
		)
		windDirectionRow.configure(with: rowModel)
	}

}


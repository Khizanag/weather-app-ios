//
//  ForecastTableHeaderView.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 25.01.21.
//

import UIKit

class ForecastTableHeaderView: UITableViewHeaderFooterView {

	static let identifier = "ForecastTableHeaderView"

	@IBOutlet weak var titleLabel: UILabel!

	override func layoutSubviews() {
		super.layoutSubviews()

		setTransparency()
	}


	private func setTransparency() {
//		tintColor = UIColor.AccentColor // TODO
	}

	public func configure(with model: ForecastSectionHeaderModel) {
		titleLabel.text = model.weekday.uppercased()
	}
}

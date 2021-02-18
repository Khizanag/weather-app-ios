//
//  ForecastTableViewCell.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 25.01.21.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

	static let identifier = "ForecastTableViewCell"

	@IBOutlet weak var icon: UIImageView!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!

	private var viewModel: ForecastViewModel?
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		backgroundColor = .clear
		contentView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


	public func configure(with model: ForecastViewModel) {
		viewModel = model

		icon.sd_setImage(
			with: URL(string: IconPathBuilder.build(for: model.iconName)),
			placeholderImage: UIImage(named: Constants.IconNames.defaultIconName))
		timeLabel.text = model.hour
		descriptionLabel.text = model.description
		temperatureLabel.text = model.temperature
	}
}

//
//  ErrorView.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 28.01.21.
//

import Foundation
import UIKit

protocol ErrorViewDelegate: AnyObject {

	func reloadTapped()

}

class ErrorView: BaseReusableView {
	
	@IBOutlet weak var descriptionLabel: UILabel!

	public weak var delegate: ErrorViewDelegate?

	public func configure(with description: String) {
		descriptionLabel.text = description
	}

	@IBAction func reloadHandler(_ sender: Any) {
		print("-- ErrorView.reloadHandler")
		delegate?.reloadTapped()
	}
}

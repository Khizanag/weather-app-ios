//
//  TransparentNavBarNavigationController.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 19.01.21.
//

import UIKit

class TransparentNavBarNavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()

		configureWithTransparentBackground()
	}

	private func configureWithTransparentBackground() {
		let navBarAppearance = UINavigationBarAppearance()
		navBarAppearance.configureWithTransparentBackground()
		navBarAppearance.backgroundImage = UIImage()
		navBarAppearance.shadowImage = UIImage()

		setNavigationBarTitleColor(for: navBarAppearance, color: .white)

		navigationBar.compactAppearance = navBarAppearance
		navigationBar.standardAppearance = navBarAppearance
		navigationBar.scrollEdgeAppearance = navBarAppearance
	}

	private func setNavigationBarTitleColor(for navBarAppearance: UINavigationBarAppearance, color colorToSet: UIColor) {
		navBarAppearance.titleTextAttributes = [.foregroundColor : colorToSet]
	}

}

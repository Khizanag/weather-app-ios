//
//  TransparentTabBarController.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 19.01.21.
//

import UIKit

class TransparentTabBarController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()

		configureWithTransparentBackground()
	}

	private func configureWithTransparentBackground() {
		let tabBarAppearance = UITabBar.appearance()
		tabBarAppearance.backgroundImage = UIImage()
		tabBarAppearance.shadowImage = UIImage()
		tabBarAppearance.barTintColor = UIColor.clear
		tabBarAppearance.clipsToBounds   = true
	}

//	public func setTitleColor() {
//		appearance.titleTextAttributes = [.foregroundColor : UIColor.red]
//	}

}


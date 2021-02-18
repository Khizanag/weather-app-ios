//
//  UIView+Extension.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 08.02.21.
//

import Foundation
import UIKit

extension UIView {

	func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
		layer.masksToBounds = false
		layer.shadowOffset = offset
		layer.shadowColor = color.cgColor
		layer.shadowRadius = radius
		layer.shadowOpacity = opacity

		let backgroundCGColor = backgroundColor?.cgColor
		backgroundColor = nil
		layer.backgroundColor =  backgroundCGColor
	}

	func addGradientWithColor(startColor: UIColor, endColor: UIColor) {
		let gradient = CAGradientLayer()
		gradient.frame = self.bounds
		gradient.colors = [startColor.cgColor, endColor.cgColor]

		self.layer.insertSublayer(gradient, at: 0)
	}
}

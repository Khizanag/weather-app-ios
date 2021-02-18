//
//  GradientBackgroundView.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 08.02.21.
//

import Foundation
import UIKit

class GradientBackgroundView: UIView {

	var gradientLayer: CAGradientLayer {
		return layer as! CAGradientLayer
	}

	override open class var layerClass: AnyClass {
		return CAGradientLayer.classForCoder()
	}

	// implement cgcolorgradient in the next section
	var startColor: UIColor? {
		didSet { gradientLayer.colors = cgColorGradient }
	}

	var endColor: UIColor? {
		didSet { gradientLayer.colors = cgColorGradient }
	}

	var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0) {
		   didSet { gradientLayer.startPoint = startPoint }
	   }

   var endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0) {
	   didSet { gradientLayer.endPoint = endPoint }
   }

	// existing code
}

extension GradientBackgroundView {
	// For this implementation, both colors are required to display
	// a gradient. You may want to extend cgColorGradient to support
	// other use cases, like gradients with three or more colors.
	var cgColorGradient: [CGColor]? {
		guard let startColor = startColor, let endColor = endColor else {
			return nil
		}

		return [startColor.cgColor, endColor.cgColor]
	}
}

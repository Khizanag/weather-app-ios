//
//  ErrorTopPopup.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 27.01.21.
//

import Foundation
import UIKit

class ErrorTopPopup: BaseReusableView {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!

	public var popOutTimer: DispatchTime = .now()

	static let numSecondsBeforeHiding = 3

	override func layoutSubviews() {
		super.layoutSubviews()
		initRoundCorners()
	}

	private func initRoundCorners() {
		contentView.layer.cornerRadius = contentView.bounds.width / 15
	}

	public func configure(title: String, description: String) {
		titleLabel.text = title
		descriptionLabel.text = description
	}

	public func updatePopOutTimer() {
		popOutTimer = .now() + .seconds(ErrorTopPopup.numSecondsBeforeHiding)

		DispatchQueue.main.asyncAfter(deadline: popOutTimer, execute: {
			if !self.isHidden {
				self.animateOut()
			}
		})
	}

	public func animateIn(viewHeight: CGFloat) {
		alpha = 0
		isHidden = false

		let offset = CGPoint(x: 0, y: -viewHeight/5)
		let x: CGFloat = 0, y: CGFloat = 0
		transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)

		UIView.animate(
			withDuration: 1,
			delay: 0,
			usingSpringWithDamping: 0.47,
			initialSpringVelocity: 3,
			options: .curveEaseOut,
			animations: {
				self.transform = .identity
				self.alpha = 1
			}
		)

	}

	public func animateOut() {
		
		isHidden = false
		alpha = 1

		UIView.animate(
			withDuration: 0.75,
			delay: 0,
			usingSpringWithDamping: 0.55,
			initialSpringVelocity: 3,
			options: .curveEaseOut,
			animations: {
				self.alpha = 0
				self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
			},
			completion: { [unowned self] _ in
				self.isHidden = true
			}
		)
	}
}

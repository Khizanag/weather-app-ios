//
//  AddCityPopup.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 27.01.21.
//

import Foundation
import MHLoadingButton
import UIKit

protocol AddCityPopupDelegate: AnyObject {
	func cityAdditionTried(cityName: String)
	func cityAdditionTextFieldWillAppear(notification: NSNotification)
	func cityAdditionTextFieldWillHide(notification: NSNotification)
}

class AddCityPopup: BaseReusableView {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var addCityButton: LoadingButton!

	public weak var delegate: AddCityPopupDelegate?

	override func awakeFromNib() {
		super.awakeFromNib()
		textField.delegate = self

		initLoadingButton()

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillAppear(notification:)),
			name: UIResponder.keyboardWillShowNotification,
			object: nil)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHide(notification:)),
			name: UIResponder.keyboardWillHideNotification,
			object: nil)
	}

	private func initLoadingButton() {
		addCityButton.withShadow = false
		addCityButton.backgroundColor = .clear
		addCityButton.bgColor = .clear
		if let loaderColor = UIColor(named: "green-gradient-end") {
			addCityButton.indicator = LineSpinFadeLoader(color: loaderColor)
		}
	}

	@objc
	private func keyboardWillAppear(notification: NSNotification) {
		delegate?.cityAdditionTextFieldWillAppear(notification: notification)
	}

	@objc
	private func keyboardWillHide(notification: NSNotification) {
		delegate?.cityAdditionTextFieldWillHide(notification: notification)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		initRoundCorners()
	}

	private func initRoundCorners() {
		contentView.layer.cornerRadius = contentView.bounds.width / 10
	}

	@IBAction func addButtonTapHandler(_ sender: Any) {

		let whiteCircle = UIImage(systemName: "circle.fill")
		addCityButton.setBackgroundImage(whiteCircle, for: .normal)
		addCityButton.showLoader([addCityButton.imageView])

		let cityName = textField.text!
		textField.resignFirstResponder()

		delegate?.cityAdditionTried(cityName: cityName)
	}

	public func animateIn(viewHeight: CGFloat) {
		alpha = 0
		isHidden = false

		let offset = CGPoint(x: 0, y: -viewHeight/2)
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

				self.textField.text = ""
				self.textField.becomeFirstResponder()
			},
			completion: nil
		)
	}

	public func reset() {
		addCityButton.hideLoader()
		let backgroundImage = UIImage(systemName: "plus.circle.fill")
		addCityButton.setBackgroundImage(backgroundImage, for: .normal)
		textField.text = ""
	}

}


extension AddCityPopup: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		addButtonTapHandler(addCityButton!)
		return true
	}

}

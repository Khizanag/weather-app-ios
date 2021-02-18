//
//  BaseReusableView.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 27.01.21.
//

import Foundation
import UIKit

class BaseReusableView: UIView {

	@IBOutlet var contentView: UIView!

	var nibName: String {
		return String(describing: Self.self)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
		setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
		setup()
	}

	func commonInit() {
		let bundle = Bundle(for: BaseReusableView.self)
		bundle.loadNibNamed(nibName, owner: self, options: nil)

		guard let contentView = contentView else { fatalError("ContentView not set") }

		contentView.frame = bounds
		contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

		addSubview(contentView)
	}

	func setup() {
		// now empty, will be overrided
	}
}

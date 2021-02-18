//
//  ForecastViewController.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 25.01.21.
//

import UIKit

class ForecastViewController: UIViewController {

	@IBOutlet var tableView: UITableView!
	@IBOutlet weak var loader: UIActivityIndicatorView!

	private let service = Service(type: .Forecast)
	private var sectionModels = [ForecastSectionModel]()
	private let errorView = ErrorView()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		initTableView()
		initErrorView()
		tabBarController?.delegate = self
		refresh(self)
	}

	private func initTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = .clear
		initTableViewRegistrations()
	}

	private func initTableViewRegistrations() {
		tableView.register(
			UINib(nibName: ForecastTableViewCell.identifier, bundle: nil),
			forCellReuseIdentifier: ForecastTableViewCell.identifier
		)

		tableView.register(
			UINib(nibName: ForecastTableHeaderView.identifier, bundle: nil),
			forHeaderFooterViewReuseIdentifier: ForecastTableHeaderView.identifier
		)
	}

	private func initErrorView() {
		errorView.isHidden = true
		errorView.delegate = self
		errorView.frame = view.bounds
		view.addSubview(errorView)
		view.bringSubviewToFront(errorView)
	}

	private func getCityToLoad() -> String {
		guard let tabBarController = tabBarController else { return "" }
		guard let viewControllers = tabBarController.viewControllers else { return "" }
		for viewController in viewControllers {
			for child in viewController.children {
				if let todayController = child as? TodayWeatherViewController {
					return todayController.getCurrentCity()
				}
			}
		}

		return ""
	}

	@IBAction func refresh(_ sender: Any) {
		sectionModels.removeAll()
		tableView.isHidden = true
		errorView.isHidden = true
		loader.startAnimating()

		let city = getCityToLoad()
		guard city != "" else { refreshFailed(with: ForecastServiceError.noCityFound); return }

		service.requestForecast(for: city) {  [weak self] result in
			guard let self = self else { return }

			DispatchQueue.main.async {
				switch result {
					case .success(let response):
						for forecastItem in response.list {
							let viewModel = ForecastViewModelBuilder.build(from: forecastItem)
							if self.sectionModels.last == nil || viewModel.hour == "00:00" { // new day
								let weekday = self.getWeekday(timeIntervalSince1970: TimeInterval(viewModel.timeFrom1970))
								let headerModel = ForecastSectionHeaderModel(weekday: weekday)
								let newSection = ForecastSectionModel(headerModel: headerModel, rowModels: [])
								self.sectionModels.append(newSection)
							}
							self.sectionModels[self.sectionModels.count-1].rowModels.append(viewModel)
						}
						self.loader.stopAnimating()
						self.tableView.isHidden = false
						self.tableView.reloadData()
					case .failure(let error):
						self.refreshFailed(with: error)
				}
			}
		}
	}

	private func refreshFailed(with error: Error) {
		print("-- ForecastViewController.refresh.service.requestForecast failed with: \(error)")
		loader.stopAnimating()
		errorView.isHidden = false
	}

	private func getWeekday(timeIntervalSince1970: TimeInterval) -> String {
		let date = Date(timeIntervalSince1970: timeIntervalSince1970)
		let f = DateFormatter()
		let weekday = f.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
		return weekday
	}

}

extension ForecastViewController: UITableViewDelegate {

	func numberOfSections(in tableView: UITableView) -> Int {
		return sectionModels.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sectionModels[section].rowModels.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath)
		if let forecastTableCell = cell as? ForecastTableViewCell {
			let viewModel = sectionModels[indexPath.section].rowModels[indexPath.row]
			forecastTableCell.configure(with: viewModel)
			return forecastTableCell
		}
		return UITableViewCell()
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ForecastTableHeaderView.identifier)
		if let forecastHeader = header as? ForecastTableHeaderView {
			forecastHeader.configure(with: sectionModels[section].headerModel)
			return forecastHeader
		}
		return nil
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 44
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 72
	}

}

extension ForecastViewController: UITableViewDataSource {}

extension ForecastViewController: ErrorViewDelegate {

	func reloadTapped() {
		refresh(self)
	}

}

extension ForecastViewController: UITabBarControllerDelegate {
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		if tabBarController.selectedIndex == 1 {
			refresh(self)
		}
	}
}

extension ForecastViewController {
	struct Constants{
		static let numDays = 5
		static let numHoursBetweenEachForecast = 3
		static let numHoursInDay = 24
		static let numForecastsInDay = 4 //numHoursInDay / numHoursBetweenEachForecast
	}
}

enum ForecastServiceError: Error {
	case noCityFound
}

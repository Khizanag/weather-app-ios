//
//  TodayWeatherViewController.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 25.01.21.
//

import CollectionViewPagingLayout
import CoreLocation
import Foundation
import ScalingCarousel
import UIKit

class TodayWeatherViewController: UIViewController {

	@IBOutlet var backgroundView: UIView!
	@IBOutlet var errorTopPopup: ErrorTopPopup!
	@IBOutlet var addCityPopup: AddCityPopup!

	@IBOutlet weak var blurView: UIView!
	@IBOutlet weak var blurEffect: UIVisualEffectView!
	@IBOutlet weak var loader: UIActivityIndicatorView!
	@IBOutlet weak var collectionView: ScalingCarouselView!
	@IBOutlet weak var citiesPageControl: UIPageControl!
	@IBOutlet weak var addCityButton: UIButton!

	private var cityWeathers: [CityWeatherViewModel]!
	private let locationManager = LocationManager()
	private let service = Service(type: .Weather)
	private let errorView = ErrorView()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		addCityButton.isHidden = true
		initPopups()
		initErrorView()

		initCitiesArray() { [weak self] result in
			guard let self = self else { return }
			DispatchQueue.main.async {

				switch result {
					case .success(_):
						self.initCitiesPageControl()
						self.initCollectionView()
						self.initLocationManager()
						self.addCityButton.isHidden = false
						self.loader.stopAnimating()
						self.collectionView.isHidden = false
					case .failure(_):
						self.loader.stopAnimating()
						self.errorView.isHidden = false
						print("***** error view should be displayed")
				}
			}
		}
	}

	private func initPopups() {
		initBlurEffect()
		initErrorTopPopup()
		initAddCityPopup()
	}
	
	private func initErrorView() {
		errorView.isHidden = true
		errorView.delegate = self
		errorView.frame = view.bounds
		view.addSubview(errorView)
	}

	private func initBlurEffect() {
		blurEffect.isHidden = true
		addTapGestureOnBlur()
	}

	private func initErrorTopPopup() {
		errorTopPopup.configure(
			title: "Error Occured",
			description: "City with that name was not found!")
		errorTopPopup.isHidden = true
	}

	private func initAddCityPopup() {
		addCityPopup.delegate = self
		addCityPopup.isHidden = true
	}

	private func initCitiesArray(completion: @escaping (Result<Bool, Error>) -> ()) {

		let userDefaults = UserDefaults.standard
		let citiesDefaultArray = userDefaults.array(forKey: UserDefaultKeys.citiesArray)
		if let cities = citiesDefaultArray as? [String] {
			cityWeathers = [CityWeatherViewModel](repeating: CityWeatherViewModel(
													city: "", countryCode: "", iconName: "", temperature: 0, mainDescription: "", cloudiness: 0, humidity: 0, windSpeed: 0, windDirection: 0), count:
												cities.count)

			loadSavedCityWeathers(cities: cities) { [weak self] result in
				guard let self = self else { return }
				DispatchQueue.main.async {
					switch result {
						case .success(_):
							completion(.success(true))
						case .failure(_):
							completion(.failure(TodayWeatherError.defaultError))
					}
				}
			}
		} else {
			print("error during getting city names")
			completion(.failure(TodayWeatherError.defaultError))
		}
	}

	private func loadSavedCityWeathers(cities: [String], completion: @escaping (Result<Bool, Error>) -> ()) {
		DispatchQueue.main.async {
			self.loader.startAnimating()
			self.collectionView.isHidden = true
			self.addCityButton.isHidden = true
		}
		let group = DispatchGroup()

		for (index, city) in cities.enumerated() {
			group.enter()
			service.loadTodayData(forCity: city) { [weak self] result in
				guard let self = self else { return }
				DispatchQueue.main.async {
					switch result {
					case .success(let response):
						let cityWeather = CityWeatherViewModelFactory.create(fromResponse: response)
						self.cityWeathers[index] = cityWeather
						group.leave()
					case .failure(let error):
						print("-- error after failure: \(error)")
						completion(.failure(ServiceError.notCompleted))
					}
				}
			}
		}

		group.notify(queue: .main) {
			completion(.success(true))
			self.loader.stopAnimating()
			self.collectionView.isHidden = false
			self.addCityButton.isHidden = false
		}
	}

	private func initCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.inset = collectionView.frame.width / 8

		initRegistrations()
		initCityDeleteGestureRecognizer()
	}

	private func initCityDeleteGestureRecognizer() {
		let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(alertDeleteCityHandler))
		collectionView.addGestureRecognizer(longPressRecognizer)
	}

	private func initLocationManager() {
		locationManager.delegate = self
		locationManager.requestAuthorization(.authorizedWhenInUse)
		locationManager.startUpdatingLocation()
	}

	@IBAction func refresh(_ sender: Any) {
		collectionView.isHidden = true
		addCityButton.isHidden = true
		errorView.isHidden = true
		loader.startAnimating()
		
		initCitiesArray() { [weak self] result in
			guard let self = self else { return }
			DispatchQueue.main.async {
				switch result {
					case .success(_):
						self.loader.stopAnimating()
						self.collectionView.isHidden = false
						self.addCityButton.isHidden = false
						self.collectionView.reloadData()
					case .failure(_):
						self.loader.stopAnimating()
						self.collectionView.isHidden = true
						self.addCityButton.isHidden = false
						self.view.bringSubviewToFront(self.errorView)
						self.errorView.isHidden = false
				}
			}
		}
	}

	@objc
	func alertDeleteCityHandler(gesture: UILongPressGestureRecognizer) {
		guard gesture.state == .ended else { return }
		let location = gesture.location(in: collectionView)
		guard let indexPath = collectionView.indexPathForItem(at: location) else { return }
		let cityToDelete = (cityWeathers[indexPath.row]).city
		let alert = UIAlertController(
			title: "Delete \(cityToDelete)?",
			message: "\(cityToDelete) will be deleted from your library. You will be still able to add in into your library any time. Delete now?",
			preferredStyle: .alert
		)

		alert.addAction(
			UIAlertAction(
				title: "Cancel",
				style: .cancel,
				handler: nil
			)
		)

		alert.addAction(
			UIAlertAction(
				title: "Delete",
				style: .destructive,
				handler: { [unowned self] _ in
					self.deleteCity(at: indexPath.row)
				}
			)
		)

		present(alert, animated: true, completion: nil)
	}

	private func deleteCity(at index: Int) {
		cityWeathers.remove(at: index)
		let indexPath = IndexPath(row: index, section: 0)
		collectionView.deleteItems(at: [indexPath])
//		collectionView.reloadSections([0])
		citiesPageControl.numberOfPages = cityWeathers.count
		UserDefaultsManager.shared.deleteCity(at: index)
		updateCitiesPageControlAfterCityDeletion(deletedAt: index)

		collectionView.didScroll()
	}

	private func updateCitiesPageControlAfterCityDeletion(deletedAt index: Int) {
		if cityWeathers.isEmpty {
			citiesPageControl.isHidden = true
		} else {
			if index == cityWeathers.count { // last city was deleted
				citiesPageControl.currentPage = cityWeathers.count - 1
			}
		}
	}

	@IBAction func newCityPageShouldBeDisplayed(_ sender: Any) {
		let indexPath = IndexPath(row: citiesPageControl.currentPage, section: 0)
		collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
		collectionView.didScroll()
	}

	private func tryAddCityOnUserLocation() {
		// TODO
	}

	// should call initCitiesArray first
	private func initCitiesPageControl() {
		citiesPageControl.numberOfPages = cityWeathers.count

		if cityWeathers.count > 0 {
			citiesPageControl.currentPage = 0
		} else {
			citiesPageControl.isHidden = true
		}

	}

	private func initRegistrations() {
		collectionView.register(
			UINib(nibName: TodayCarouselViewCell.identifier, bundle: nil),
			forCellWithReuseIdentifier: TodayCarouselViewCell.identifier
		)
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		collectionView.deviceRotated()
	}

	@IBAction private func addNewCityButtonTapHandler() {
		animateInBlurEffect()
		addCityPopup.animateIn(viewHeight: self.view.frame.maxY)
	}

	private func animateInBlurEffect() {
		blurEffect.alpha = 0
		blurEffect.isHidden = false
		blurEffect.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

		UIView.animate(
			withDuration: 0.75,
			delay: 0,
			usingSpringWithDamping: 0.55,
			initialSpringVelocity: 3,
			options: .curveEaseOut,
			animations: {
				self.blurEffect.transform = .identity
				self.blurEffect.alpha = 1
			},
			completion: nil
		)
	}

	private func addTapGestureOnBlur() {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideAddCityView))
		blurEffect.addGestureRecognizer(tapGestureRecognizer)
	}

	@objc
	func hideAddCityView(tapGestureRecognizer: UITapGestureRecognizer) {
		let location = tapGestureRecognizer.location(in: view)
		if addCityPopup.frame.contains(location) {
			addCityPopup.textField.resignFirstResponder()
		} else {
			animateOutAddCityPage()
		}
	}

	private func animateOutAddCityPage() {
		blurEffect.alpha = 1

		UIView.animate(
			withDuration: 0.2,
			delay: 0,
			options: UIView.AnimationOptions.curveEaseOut,
			animations: {
				self.blurEffect.alpha = 0.0
				self.addCityPopup.textField.resignFirstResponder()
			},
			completion: { [unowned self] _ in
				blurEffect.isHidden = true
				errorTopPopup.isHidden = true
				addCityPopup.isHidden = true
			}
		)
	}
	
}

extension TodayWeatherViewController: UICollectionViewDelegate {

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		collectionView.didScroll()
	}

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		citiesPageControl.currentPage = collectionView.currentCenterCellIndex!.row
	}
}

extension TodayWeatherViewController: UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1 // default only section
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cityWeathers.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCarouselViewCell.identifier, for: indexPath)
		if let carouselCell = cell as? TodayCarouselViewCell {
			let color = getColorForCarouselCell(index: indexPath.row)
			carouselCell.configure(model: cityWeathers[indexPath.row], color: color)
			return carouselCell
		}
		return cell
	}

	private func getColorForCarouselCell(index: Int) -> UIColor {
		let colorNames = TodayWeatherViewController.colorNameArrayForCarousel
		let name = colorNames[index % colorNames.count]
		let color = UIColor(named: name)
		return color ?? .red
	}

}

extension TodayWeatherViewController: AddCityPopupDelegate {

	func cityAdditionTextFieldWillAppear(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y == 0 {
				self.view.frame.origin.y -= keyboardSize.height/3
			}
		}
	}

	func cityAdditionTextFieldWillHide(notification: NSNotification) {
		if self.view.frame.origin.y != 0 {
			self.view.frame.origin.y = 0
		}
	}


	func cityAdditionTried(cityName: String) {
		let cityIndex = getCityIndex(cityName)
		if cityIndex != -1 {
			// city was already saved
			citiesPageControl.currentPage = cityIndex
			newCityPageShouldBeDisplayed(self)
			collectionView.didScroll()
			addCityPopup.reset()
			animateOutAddCityPage()
			return
		}

		service.loadTodayData(forCity: cityName) { [weak self] result in
			guard let self = self else { return }
			DispatchQueue.main.async {
				switch result {
					case .success(let response):
						self.addCityPopup.reset()
						self.animateOutAddCityPage()

						self.addCity(response: response)
					case .failure(let error):
						print("-- cityAdditionTried.failure: \(error)")
						self.addCityPopup.reset()
						self.errorTopPopup.animateIn(viewHeight: self.view.frame.maxY)
						self.errorTopPopup.updatePopOutTimer()
				}
			}
		}

	}

	private func addCity(response: TodayWeatherResponse) {
		let newCityWeather = CityWeatherViewModelFactory.create(fromResponse: response)

		self.cityWeathers.append(newCityWeather)
		UserDefaultsManager.shared.insertCity(newCityWeather.city)

		UIView.animate(
			withDuration: 0.5,
			delay: 0,
			usingSpringWithDamping: 0.47,
			initialSpringVelocity: 3,
			options: .curveEaseOut,
			animations: {
				self.citiesPageControl.isHidden = false
				self.citiesPageControl.numberOfPages = self.cityWeathers.count
				self.collectionView.reloadSections([0])
				self.citiesPageControl.currentPage = self.citiesPageControl.numberOfPages-1
				self.newCityPageShouldBeDisplayed(self)
			},
			completion: nil
		)

	}

	private func getCityIndex(_ city: String) -> Int {
		let cityToCheck = city.lowercased()
		for i in 0 ..< cityWeathers.count {
			if cityWeathers[i].city.lowercased() == cityToCheck {
				return i
			}
		}
		return -1
	}

	public func getCurrentCity() -> String {
		let currentIndex = citiesPageControl.currentPage
		return cityWeathers[currentIndex].city
	}
	
}

extension TodayWeatherViewController: ErrorViewDelegate {

	func reloadTapped() {
		errorView.isHidden = true
		refresh(self)
	}

}


extension TodayWeatherViewController: LocationManagerDelegate {
	func locationWasAllowed() {
		print("-- TodayWeatherViewController.locationWasAllowed")
	}

	func locationWasDenied() {
		print("-- TodayWeatherViewController.locationWasDenied")
		// TODO
	}

	func locationUpdated(to location: CLLocation) {
		print("-- TodayWeatherViewController.locationUpdated")
		// TODO
		let coordinate = location.coordinate
		let latitude = coordinate.latitude
		let longtitude = coordinate.longitude

		service.loadTodayData(forLocation: (latitude, longtitude)) { [weak self] result in
			DispatchQueue.main.async {
				guard let self = self else { return }
				switch result {
					case .success(let response):
						print(response)
						let city = response.name
						print("city from location: \(city)")
						let cityIndex = self.getCityIndex(city)
						print("cityIndex: \(cityIndex)")
						if cityIndex == -1 {
							self.addCity(response: response)
						} else {
							self.citiesPageControl.currentPage = cityIndex
							self.newCityPageShouldBeDisplayed(cityIndex)

						}
					case .failure(let error):
						print(error)
				}
			}
		}
	}

	func locationFailed(with error: Error) {
		print("-- TodayWeatherViewController.locationFailed")
		// TODO
	}

}




// static properties
extension TodayWeatherViewController {

	static let colorNameArrayForCarousel = [
		"green-gradient-start",
		"blue-gradient-start",
		"ochre-gradient-start",
	]

}

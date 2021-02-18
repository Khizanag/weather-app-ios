//
//  LocationManager.swift
//  Weather App
//
//  Created by Giga Khizanishvili on 31.01.21.
//

import CoreData
import Foundation
import UIKit

protocol LocationManagerDelegate: AnyObject {

	func locationWasAllowed()
	func locationWasDenied()
	func locationUpdated(to location: CLLocation)
	func locationFailed(with error: Error)
	
}

class LocationManager: NSObject {

	public weak var delegate: LocationManagerDelegate?

	private let manager = CLLocationManager()

	override init(){
		super.init()
		manager.delegate = self
		manager.requestWhenInUseAuthorization()
		manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		manager.distanceFilter = kCLDistanceFilterNone
	}

	public func requestAuthorization(_ mode: CLAuthorizationStatus) {
		print("-- requestAuthorization")
	}

	public func startUpdatingLocation() {
		manager.startUpdatingLocation()
	}

}

extension LocationManager: CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .authorizedAlways, .authorizedWhenInUse:
			delegate?.locationWasAllowed()
		case .denied, .restricted, .notDetermined:
			delegate?.locationWasDenied()
		default:
			break
		}
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("-- locationManager: didUpdateLocations")
		guard locations.count > 0, locations.first != nil else { return }
		let location = locations.first!
		delegate?.locationUpdated(to: location)
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("-- locationManager.didFailWithError")
		delegate?.locationFailed(with: error)
	}

}

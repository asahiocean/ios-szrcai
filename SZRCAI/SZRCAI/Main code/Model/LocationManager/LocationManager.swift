import Foundation
import CoreLocation

typealias LM = LocationManager

@objc class LocationManager: CLLocationManager {
    
    public static let shared = LocationManager()
    var status: CLAuthorizationStatus! = .denied
    
    func authorization() {
        if status != .authorizedWhenInUse {
            requestWhenInUseAuthorization()
        } else {
            startUpdatingLocation()
        }
    }
    
    fileprivate override init() {
        super.init()
        authorization()
        delegate = self
        desiredAccuracy = kCLLocationAccuracyBest
        distanceFilter = kCLDistanceFilterNone
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
        switch status {
        case .authorized, .authorizedWhenInUse, .authorizedAlways:
            print("Access")
            manager.startUpdatingLocation()
        case .notDetermined, .restricted, .denied:
            print("No access")
            manager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError()
        }
    }
}

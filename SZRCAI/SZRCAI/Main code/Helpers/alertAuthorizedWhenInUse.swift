import UIKit

typealias UIApp = UIApplication

func alertAuthorizedWhenInUse() -> UIAlertController {
    let alert = UIAlertController(title: "You have banned location tracking", message: "To resume tracking location, grant the app access to geolocation in your iPhone settings\n(Privacy > Location Services)", preferredStyle: .alert)
    
    alert.addAction(.init(title: "Close", style: .cancel))
    alert.addAction(.init(title: "Settings", style: .default, handler: { _ in
        let settings = UIApp.openSettingsURLString
        if let id = Bundle.main.bundleIdentifier,
           let url = URL(string: "\(settings)&path=LOCATION/\(id)") {
            UIApp.shared.open(url)
        }
    }))
    return alert
}

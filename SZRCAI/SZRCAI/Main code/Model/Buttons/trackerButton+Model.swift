import UIKit
import MapKit

extension Model {
    func trackerButton(mv mapView: MKMapView?) -> UIButton? {
        guard let mapView = mapView else { return nil }
        let sqroot = mapView.frame.width.squareRoot()
        
        // MARK: Map Kit Tracking Button
        let button = MKUserTrackingBarButtonItem(mapView: mapView)
        button.customView?.tintColor = .systemBlue
        let size = CGSize(width: sqroot * 2.5, height: sqroot * 2.5)
        button.customView?.frame.size = size
        
        guard let customView = button.customView else { return nil }
        
        // MARK: Toolbar
        // Used to display the states of MKUserTrackingBarButtonItem
        let toolbar = UIToolbar(frame: customView.frame)
        toolbar.barTintColor = .white
        toolbar.isTranslucent = true
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [flex, button, flex]
        
        let view = UIButton(frame: toolbar.frame)
        view.layer.cornerRadius = view.bounds.width / 2
        view.layer.borderWidth = 2
        view.layer.borderColor = toolbar.tintColor.cgColor
        
        view.layer.masksToBounds = true
        
        view.center.y = mapView.frame.midY
        view.frame.origin.x = mapView.frame.maxX - (view.bounds.width + sqroot)
        view.addSubview(toolbar)
        self.trackingButton = view
        return trackingButton
    }
}

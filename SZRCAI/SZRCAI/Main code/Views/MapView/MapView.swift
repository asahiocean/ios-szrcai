import UIKit
import MapKit

class MapView: MKMapView {
    
    var model: Model = .shared
    weak var lm: LocationManager? = .shared
    
    @objc fileprivate func appendPin(_ sender: UILongPressGestureRecognizer) {
        guard model.graphsBuilt == false else { return }
        if sender.state != .began { return }
        
        let point = sender.location(in: self)
        let coord = convert(point, toCoordinateFrom: self)
        
        let annotation = PinAnnotation(t: "PIN", sub: nil, c: coord)
        self.addAnnotation(annotation)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mapType = .standard
        
        showsUserLocation = true
        userTrackingMode = .none
        
        if #available(iOS 13.0, *) {
            pointOfInterestFilter = .none
        } else {
            showsPointsOfInterest = true
        }
        
        showsCompass = true
        showsScale = true
        isZoomEnabled = true
        isScrollEnabled = true
        
        let longPress = UILongPressGestureRecognizer()
        longPress.minimumPressDuration = 0.25 // in sec
        longPress.addTarget(self, action: #selector(appendPin(_:)))
        addGestureRecognizer(longPress)
        
        register(PinMarkerView.self, forAnnotationViewWithReuseIdentifier: PinMarkerView.reuseId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

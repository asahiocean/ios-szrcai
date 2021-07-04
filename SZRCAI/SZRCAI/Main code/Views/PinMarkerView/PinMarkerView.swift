import Foundation
import MapKit.MKAnnotationView

class PinMarkerView: MKMarkerAnnotationView {
    
    fileprivate func setup() {
        canShowCallout = true
        animatesWhenAdded = true
        
        collisionMode = .circle
        markerTintColor = .magenta
        
        displayPriority = .required
        clusteringIdentifier = PinMarkerView.reuseId
        
        let n = frame.height * 0.75
        let size = CGSize(width: n, height: n)
        let button = UIButton(frame: .init(origin: .zero, size: size))
        button.setImage(#imageLiteral(resourceName: "trash"), for: .normal)
        rightCalloutAccessoryView = button
    }
    
    override var annotation: MKAnnotation? {
        didSet { self.setup() }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import UIKit
import MapKit

extension ViewController: MKMapViewDelegate {
    
    //MARK: - MKOverlayRenderer
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case let dashline as DashLine:
            let renderer = MKPolylineRenderer(polyline: dashline)
            renderer.strokeColor = #colorLiteral(red: 0.2470588237, green: 0.3882353008, blue: 0.5450980663, alpha: 0.685907326)
            renderer.lineWidth = 5
            renderer.lineDashPattern = [0, 10]
            return renderer
        case is MKPolyline:
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemRed
            renderer.lineWidth = 5
            return renderer
        default:
            return .init()
        }
    }
    
    //MARK: - MKUserTrackingMode
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if lm.shared.status != .authorizedWhenInUse {
            let alert = alertAuthorizedWhenInUse()
            present(alert, animated: true, completion: {
                mapView.userTrackingMode = .none
            })
        }
    }
    
    //MARK: - Did select annotation view
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        mapView.deselectAnnotation(annotation, animated: true)
        Model.shared.selected = nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        if let pin = annotation as? PinAnnotation {
            mapView.selectAnnotation(pin, animated: true)
            // If the graph is built, give the opportunity to choose the starting and ending point
            if Model.shared.graphsBuilt { Model.shared.selected = pin }
        }
    }
    
    //MARK: - MKAnnotationView constructor
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case let pin as PinAnnotation:
            let id = PinMarkerView.reuseId
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: id, for: pin)
            Model.shared.pins.append(pin)
            return view
        default:
            return nil
        }
    }
    
    //MARK: - calloutAccessoryControlTapped -
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        switch view.annotation {
        case let pin as PinAnnotation:
            guard let annotation = view.annotation else { return }
            Model.shared.pins.removeAll(where: { $0 == pin })
            Model.shared.route.removeAll(where: { $0 == pin })
            mapView.removeAnnotation(annotation)
            // After removing the marker, the graphs will be rebuilt
            self.constructGraphs()
        default: break
        }
    }
}

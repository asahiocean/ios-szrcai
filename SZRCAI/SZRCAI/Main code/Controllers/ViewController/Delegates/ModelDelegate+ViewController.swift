import UIKit
import MapKit
import CoreLocation

extension ViewController: ModelDelegate {
    
    func deselectPin(pin annotation: PinAnnotation) {
        mapView.deselectAnnotation(annotation, animated: true)
        guard let view = mapView.view(for: annotation) else { return }
        if let marker = view as? MKMarkerAnnotationView  {
            marker.markerTintColor = annotation.markerColor
        }
    }
    
    func modelButtonExecute(sender: UIButton) {
        let m = mapView.model
        let tag = Model.buttonTag(rawValue: sender.tag)
        switch tag {
        case .graphs:
            print("Trying to build graphs...")
            constructGraphs()
        case .start:
            if m.selected != nil {
                print("User has chosen a starting point!")
            } else { /* ... */ }
        case .finish:
            if m.selected != nil {
                print("User selected endpoint!")
            } else { /* ... */ }
        case .routecalc:
            print("Trying to make the shortest route!")
            let coords = m.route.compactMap({ $0.coordinate })
            for (i,coord) in coords.enumerated() {
                if (i+1) < coords.count {
                    createRouteTo(from: coord, to: coords[i+1])
                }
            }
            mainButton?.removeTarget(nil, action: nil, for: .allEvents)
        case .clear:
            clearingMap()
            print("❌ Clearing the map...")
        default:
            fatalError()
        }
    }
    
    func createRouteTo(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        let CLL2DIsValid = CLLocationCoordinate2DIsValid
        if CLL2DIsValid(from) && CLL2DIsValid(to) {
            let req = MKDirections.Request()
            req.source = .init(placemark: .init(coordinate: from))
            req.destination = .init(placemark: .init(coordinate: to))
            req.requestsAlternateRoutes = false
            req.transportType = .any
            
            let directions = MKDirections(request: req)
            
            directions.calculate { [self] (resp, error) in
                guard let response = resp else {
                    if let error = error {
                        // MARK: Error message while building a route
                        let alert = UIAlertController(title: "FAILED TO CREATE A ROUTE",
                                                      message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(.init(title: "Remove annotations", style: .destructive, handler: {_ in clearingMap() }))
                        present(alert, animated: true)
                    }
                    return
                }
                enum TransportType: UInt {
                    case automobile = 1, walking, transit
                    var value: String {
                        switch self {
                        case .automobile: return "car"
                        case .walking: return "walk"
                        case .transit: return "transit"
                        }
                    }
                }
                guard let route = response.routes.first else { return }
                mapView.addOverlay(route.polyline)
                let transport = (TransportType(rawValue: route.transportType.rawValue)?.value ?? "")
                mapView.model.mainButton?.setTitle("\(Int((route.expectedTravelTime)/60)) min / \(transport)", for: .normal)
            }
        }
    }
    
    // Clearing the entire map of annotations and overlays (including graphs)
    fileprivate func clearingMap() {
        DispatchQueue.main.async { [mapView] () -> Void in
            mapView?.model.pins.removeAll()
            mapView?.model.route.removeAll()
            mapView?.model.graphsBuilt = false
            mapView?.overlays.forEach({ mapView?.removeOverlay($0) })
            mapView?.annotations.forEach({ mapView?.removeAnnotation($0) })
        }
    }
    
    internal func constructGraphs() {
        mapView.removeOverlays(mapView.overlays)
        
        let pins = mapView.annotations.filter({ $0.isKind(of: PinAnnotation.self) })
        let coords = pins.compactMap({ $0.coordinate })
        
        coords.forEach({ (start: CLLocationCoordinate2D) in
            let vertices = coords.filter({ $0 != start }) // getting all vertices excluding the starting point
            
            vertices.forEach({ (end: CLLocationCoordinate2D) in // enumeration of all vertices
                let locations = [start, end] // start and end vertices
                
                // MARK: вершины соединены ребрами при условии, что расстояние между вершинами не более 5км
                // condition: vertices are connected by edges, provided that the distance between the vertices is no more than 5 km
                if locations.distance < 5000 {
                    let dashline = DashLine(with: locations)
                    
                    // you can also delegate the storage of all vertices and graphs
                    // to into a separate class in which can their compare for find matches
                    let exists = mapView.overlays.contains(where: { $0.coordinate == dashline.coordinate })
                    
                    guard !exists else { return }
                    
                    // creating a graph between vertices
                    mapView?.addOverlay(dashline)
                    
                    if !mapView.model.graphsBuilt {
                        mapView.model.graphsBuilt = true
                    }
                    
                    print("graphs count:", mapView.overlays.count)
                } else {
                    let alert = UIAlertController(title: "Point is too far away!",
                                                  message: "The distance between the vertices should not be more than 5 km.",
                                                  preferredStyle: .alert)
                    alert.addAction(.init(title: "ОК", style: .cancel))
                    present(alert, animated: true)
                }
            })
        })
    }
}

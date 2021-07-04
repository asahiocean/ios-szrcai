import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    
    public var location: CLLocation {
        return .init(latitude: latitude, longitude: longitude)
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
    }
    
    public static func !=(lhs: Self, rhs: Self) -> Bool {
        return !(lhs == rhs)
    }
}


extension Array where Element == CLLocationCoordinate2D {
    /// - Tag: Distance
    public var distance: CLLocationDistance {
        guard let first = first, let last = last else { return 0 }
        return first.location.distance(from: last.location)
    }
}

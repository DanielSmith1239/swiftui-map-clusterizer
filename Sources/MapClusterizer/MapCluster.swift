import MapKit

public struct MapCluster<Value: MapClusterable> {
    
    public let id: Int
    public let values: [Value]
    public let center: CLLocationCoordinate2D
    public let radius: Double
    
    init(id: Int, values: [Value]) {
        self.id = id
        self.values = values
        self.center = _center(of: values)
        self.radius = _radius(of: values)
    }
    
}

fileprivate func _center(of values: [some MapClusterable]) -> CLLocationCoordinate2D {
    
    let latitudes = values.map(\.location.latitude)
    
    let longitudes = values.map(\.location.longitude)
    
    let minLatitude = latitudes.min()!
    let maxLatitude = latitudes.max()!
    
    let minLongitude = longitudes.min()!
    let maxLongitude = longitudes.max()!
    
    let centerLatitude = (maxLatitude + minLatitude)/2
    let centerLongitude = (maxLongitude + minLongitude)/2
            
    return CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
    
}

fileprivate func _radius(of values: [some MapClusterable]) -> Double {
    
    let latitudes = values.map(\.location.latitude)
    
    let longitudes = values.map(\.location.longitude)
    
    let minLatitude = latitudes.min()!
    let maxLatitude = latitudes.max()!
    
    let minLongitude = longitudes.min()!
    let maxLongitude = longitudes.max()!
    
    let minLocation = CLLocation(latitude: minLatitude, longitude: minLongitude)
    let maxLocation = CLLocation(latitude: maxLatitude, longitude: maxLongitude)
    
    return minLocation.distance(from: maxLocation)
    
}

extension MapCluster: Identifiable { }

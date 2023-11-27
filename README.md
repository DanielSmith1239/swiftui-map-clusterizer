```swift

import SwiftUI
import MapKit
import MapClusterizer

struct Place: Identifiable {
    let id: Int
    let location: CLLocationCoordinate2D
}

extension Place: Equatable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.id == rhs.id
    }
}

extension Place: MapClusterable { }

struct ContentView: View {
        
    @State var places: [Place] = [
        Place(id: 0, location: CLLocationCoordinate2D(latitude: 51.46835549272785, longitude: -0.03750000000003133)),
        Place(id: 1, location: CLLocationCoordinate2D(latitude: 51.457013659530155, longitude: -0.14905556233727052)),
        Place(id: 2, location: CLLocationCoordinate2D(latitude: 51.44401205914533, longitude: -0.005055562337271016)),
        Place(id: 3, location: CLLocationCoordinate2D(latitude: 51.4276908863969, longitude: -0.10683333333336441)),
        Place(id: 4, location: CLLocationCoordinate2D(latitude: 51.29601501405658, longitude: -0.22550000000003068)),
    ]
        
    @State private var coordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), 
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
        
    var body: some View {
        
        MapClusterizer(coordinateRegion: $coordinateRegion, clusterables: places) { clusters in
            Map(coordinateRegion: $coordinateRegion, annotationItems: clusters) { cluster in
                MapAnnotation(coordinate: cluster.center) {
                    ClusterView(cluster: cluster) {
                        withAnimation {
                            coordinateRegion.center = cluster.center
                            coordinateRegion.span = .init(
                                latitudeDelta: coordinateRegion.span.latitudeDelta/2,
                                longitudeDelta: coordinateRegion.span.longitudeDelta/2
                            )
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        
    }
    
}

struct ClusterView: View {
    
    let cluster: MapCluster<Place>
    
    let action: () -> Void
    
    var body: some View {
        Circle()
            .fill(.orange)
            .frame(width: 30, height: 30)
            .overlay {
                if cluster.values.count > 1 {
                    Text(cluster.values.count.formatted())
                        .bold()
                }
            }
            .onTapGesture(perform: action)
    }
}

```

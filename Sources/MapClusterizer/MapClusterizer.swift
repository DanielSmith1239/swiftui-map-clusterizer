import SwiftUI
import MapKit
import Combine

@available(iOS 17.0, *)
public struct MapClusterizer<Content: View, Item>: View where Item: MapClusterable {
    
    let clusterables: [Item]
    
    var content: ([MapCluster<Item>], Proxy) -> Content
    
    @Binding var position: MapCameraPosition
    @Binding var region: MKCoordinateRegion

    @State private var clusters: [MapCluster<Item>] = []
    
    @State private var mapSpanLatitudeDeltaDidChange = PassthroughSubject<CLLocationDegrees, Never>()
    
    public init(position: Binding<MapCameraPosition>, region: Binding<MKCoordinateRegion>, clusterables: [Item], content: @escaping ([MapCluster<Item>], Proxy) -> Content) {
        self._position = position
        self.clusterables = clusterables
        self.content = content
        self._region = region
    }
   
    public var body: some View {
        content(clusters, Proxy(position: $position))
            .onChange(of: region.span.latitudeDelta) { newValue in
                mapSpanLatitudeDeltaDidChange.send(region.span.latitudeDelta)
            }
            .onReceive(mapSpanLatitudeDeltaDidChange.debounce(for: 0.1, scheduler: RunLoop.main)) { newValue in
                let updatedClusters = clusterables.clusterize(region: region)
                if updatedClusters.count != clusters.count {
                    clusters = updatedClusters
                }
            }
            .onAppear {
                clusters = clusterables.clusterize(region: region)
            }
    }
    
}

@available(iOS 17.0, *)
extension MapClusterizer {
    
    @available(iOS 17.0, *)
    public struct Proxy {
        
        @Binding var position: MapCameraPosition
        
        public func zoom(on cluster: MapCluster<Item>, factor: Double = 3) {
            var distance: Double = 0
            
            cluster.values.forEach { place in
                cluster.values.forEach { other in
                    if other == place { return }
                    distance = max(distance, place.distance(to: other))
                }
            }
            
            position = .region(MKCoordinateRegion(center: cluster.center, latitudinalMeters: distance * factor, longitudinalMeters: distance * factor))
        }
        
    }
    
}

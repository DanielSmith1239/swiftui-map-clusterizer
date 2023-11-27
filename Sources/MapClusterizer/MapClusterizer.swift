import SwiftUI
import MapKit
import Combine

public struct MapClusterizer<Content: View, Item>: View where Item: MapClusterable {
    
    let clusterables: [Item]
    
    var content: ([MapCluster<Item>]) -> Content
    
    @Binding var coordinateRegion: MKCoordinateRegion
    
    @State private var clusters: [MapCluster<Item>] = []
    
    @State private var mapSpanLatitudeDeltaDidChange = PassthroughSubject<CLLocationDegrees, Never>()
    
    public init(coordinateRegion: Binding<MKCoordinateRegion>, clusterables: [Item], content: @escaping ([MapCluster<Item>]) -> Content) {
        self._coordinateRegion = coordinateRegion
        self.clusterables = clusterables
        self.content = content
    }
   
    public var body: some View {
        content(clusters)
            .onChange(of: coordinateRegion.span.latitudeDelta) { _ in
                mapSpanLatitudeDeltaDidChange.send(coordinateRegion.span.latitudeDelta)
            }
            .onReceive(mapSpanLatitudeDeltaDidChange.debounce(for: 0.1, scheduler: RunLoop.main)) { newValue in
                clusters = clusterables.clusterize(region: coordinateRegion)
            }
            .onAppear {
                clusters = clusterables.clusterize(region: coordinateRegion)
            }
    }
    
}

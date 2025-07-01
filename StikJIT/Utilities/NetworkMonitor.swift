import Foundation
import Network

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    @Published private(set) var isCellularActive: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            // "Cellular" is considered an expensive interface; however we specifically
            // check the interface type to avoid false-positives (e.g. Personal Hotspot).
            self.isCellularActive = path.usesInterfaceType(.cellular)
        }
        monitor.start(queue: queue)
    }
} 
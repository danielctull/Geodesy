
import Geodesy

extension Coordinate {

    init(latitude: Double,
         longitude: Double,
         accuracy: Double = 0,
         system: CoordinateSystem = .wgs84
    ) {
        self.init(latitude: .degrees(latitude),
                  longitude: .degrees(longitude),
                  accuracy: accuracy,
                  system: system)
    }
}

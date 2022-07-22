
import Foundation

public struct Angle {

    public let radians: Double
    public var degrees: Double { radians * 180 / .pi }

    public init(radians: Double) {
        self.radians = radians
    }

    public init(degrees: Double) {
        self.radians = degrees / 180 * .pi
    }

    public init(arcseconds: Double) {
        self.init(degrees: arcseconds / 3600)
    }
}


import Foundation

public struct Angle: Equatable {

    public let radians: Double
    public var degrees: Double { radians * 180 / .pi }
    public var arcseconds: Double { degrees * 3600 }

    private init(radians: Double) {
        self.radians = radians
    }
}

extension Angle {

    public static func radians(_ radians: Double) -> Angle {
        Angle(radians: radians)
    }

    public static func degrees(_ degrees: Double) -> Angle {
        .radians(degrees / 180 * .pi)
    }

    public static func arcseconds(_ arcseconds: Double) -> Angle {
        .degrees(arcseconds / 3600)
    }
}

extension Angle {

    public static prefix func - (angle: Angle) -> Angle {
        .radians(-angle.radians)
    }
}

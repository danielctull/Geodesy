
import Foundation

struct CartesianCoordinate3D {
    let x: Double
    let y: Double
    let z: Double
}

extension CartesianCoordinate3D {

    func apply(_ transform: HelmertTransform) -> CartesianCoordinate3D {

        // apply helmert transform using appropriate params

        let tx = transform.translateX
        let ty = transform.translateY
        let tz = transform.translateZ

        // normalise seconds to radians
        let rx = transform.rotateX.radians
        let ry = transform.rotateY.radians
        let rz = transform.rotateZ.radians

        // normalise ppm to (s+1)
        let s = transform.scale / 1e6 + 1

        // apply transform
        let x2 = tx + (x * s)  - (y * rz) + (z * ry)
        let y2 = ty + (x * rz) + (y * s)  - (z * rx)
        let z2 = tz - (x * ry) + (y * rx) + (z * s)

        return CartesianCoordinate3D(x: x2, y: y2, z: z2)
    }
}

extension Coordinate {

    func cartesianCoordinates(
        using ellipsoid: Ellipsoid
    ) -> CartesianCoordinate3D {

        let a = ellipsoid.semiMajorAxis
        let b = ellipsoid.semiMinorAxis

        let sinPhi = sin(latitude.radians)
        let cosPhi = cos(latitude.radians)
        let sinLambda = sin(longitude.radians)
        let cosLambda = cos(longitude.radians)
        let H = 24.7  // for the moment

        let eSq = (a * a - b * b) / (a * a)
        let nu = a / sqrt(1 - eSq * sinPhi * sinPhi)

        let x = (nu + H) * cosPhi * cosLambda
        let y = (nu + H) * cosPhi * sinLambda
        let z = ((1 - eSq) * nu + H) * sinPhi
        return CartesianCoordinate3D(x: x, y: y, z: z)
    }
}

extension CartesianCoordinate3D {

    func polarCoordinates(using ellipsoid: Ellipsoid) -> (Angle, Angle) {

        let a = ellipsoid.semiMajorAxis
        let b = ellipsoid.semiMinorAxis
        let precision = 4 / a;  // results accurate to around 4 metres

        let eSq = (a * a - b * b) / (a * a)
        let p = sqrt(x * x + y * y)
        var phi = atan2(z, p * (1 - eSq))
        var phiP = 2 * Double.pi

        var nu = Double.zero
        while fabs(phi - phiP) > precision {
            nu = a / sqrt(1 - eSq * sin(phi) * sin(phi))
            phiP = phi
            phi = atan2(z + eSq * nu * sin(phi), p)
        }

        let lambda = atan2(y, x)

        return (.radians(phi), .radians(lambda))
    }
}

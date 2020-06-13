
import Foundation

public struct Coordinate {

	public let latitude: Double
	public let longitude: Double
	public let accuracy: Double
	public let system: CoordinateSystem

	public init(latitude: Double, longitude: Double, accuracy: Double = 0, system: CoordinateSystem = .wgs84) {
		self.latitude = latitude
		self.longitude = longitude
		self.system = system
		self.accuracy = accuracy
	}
}

extension Coordinate {

	public func convert(to newSystem: CoordinateSystem) -> Coordinate {

		let datumTransform = HelmertDatumTransform(from: system.datum, to: newSystem.datum)

		// -- 1: convert polar to cartesian coordinates (using ellipse 1)

		let lat = radians(from: latitude)
		let lon = radians(from: longitude)

		let e1 = system.ellipsoid
		let e2 = newSystem.ellipsoid

		var a = e1.semiMajorAxis
		var b = e1.semiMinorAxis

		let sinPhi = sin(lat)
		let cosPhi = cos(lat)
		let sinLambda = sin(lon)
		let cosLambda = cos(lon)
		var H = 24.7  // for the moment

		var eSq = (a * a - b * b) / (a * a)
		var nu = a / sqrt(1 - eSq * sinPhi * sinPhi)

		let x1 = (nu + H) * cosPhi * cosLambda
		let y1 = (nu + H) * cosPhi * sinLambda
		let z1 = ((1 - eSq) * nu + H) * sinPhi

		// -- 2: apply helmert transform using appropriate params

		let tx = datumTransform.transformX
		let ty = datumTransform.transformY
		let tz = datumTransform.transformZ

		// normalise seconds to radians
		let rx = radians(from: datumTransform.rotateX / 3600)
		let ry = radians(from: datumTransform.rotateY / 3600)
		let rz = radians(from: datumTransform.rotateZ / 3600)

		// normalise ppm to (s+1)
		let s1 = datumTransform.scale / 1e6 + 1

		// apply transform
		let x2 = tx + (x1 * s1) - (y1 * rz) + (z1 * ry)
		let y2 = ty + (x1 * rz) + (y1 * s1) - (z1 * rx)
		let z2 = tz - (x1 * ry) + (y1 * rx) + (z1 * s1)

		// -- 3: convert cartesian to polar coordinates (using ellipse 2)

		a = e2.semiMajorAxis
		b = e2.semiMinorAxis
		let precision = 4 / a;  // results accurate to around 4 metres

		eSq = (a * a - b * b) / (a * a)
		let p = sqrt(x2 * x2 + y2 * y2)
		var phi = atan2(z2, p * (1 - eSq))
		var phiP = 2 * Double.pi

		while fabs(phi - phiP) > precision {
			nu = a / sqrt(1 - eSq * sin(phi) * sin(phi))
			phiP = phi
			phi = atan2(z2 + eSq * nu * sin(phi), p)
		}

		let lambda = atan2(y2, x2)
		H = p / cos(phi) - nu

		let newLatitude = degrees(from: phi)
		let newLongitude = degrees(from: lambda)

		return Coordinate(
			latitude: newLatitude,
			longitude: newLongitude,
			accuracy: accuracy + datumTransform.accuracy,
			system: newSystem)
	}
}

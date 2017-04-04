
public struct OSGridReference {
	public let gridSquareLetters: String
	public let easting: Int
	public let northing: Int
}




extension OSGridReference {

	public init?(coordinate inCoordinate: Coordinate) {

		var coordinate = inCoordinate

		// If the coordinate is not in the OSGB36 system,
		// let's try to convert it.
		if coordinate.system != .osgb36 {
			coordinate = coordinate.convert(to: .osgb36)
		}

		// Do a sanity check here to make sure the
		// coordinate is now in the OSGB36 system.
		guard coordinate.system == .osgb36 else {
			return nil
		}


		let lat = radians(from: coordinate.latitude)
		let lon = radians(from: coordinate.longitude)

		// Airy 1830 major & minor semi-axes
		let a = Ellipsoid.airy1830.semiMajorAxis
		let b = Ellipsoid.airy1830.semiMinorAxis

		// National Grid scale factor on central meridian
		let F0 = 0.9996012717

		// National Grid true origin is 49ºN,2ºW
		let lat0 = radians(from: 49)
		let lon0 = radians(from: -2)

		// northing & easting of true origin, metres
		let N0: Double = -100000
		let E0: Double = 400000

		// eccentricity squared
		let e2 = 1 - (b * b) / (a * a)

		let n = (a - b) / (a + b)
		let n2 = n * n
		let n3 = n * n * n


		let cosLat = cos(lat)
		let sinLat = sin(lat)

		// transverse radius of curvature
		let nu = a * F0 / sqrt(1 - e2 * sinLat * sinLat)

		// meridional radius of curvature
		let rho = a * F0 * (1 - e2) / pow(1 - e2 * sinLat * sinLat, 1.5)

		let eta2 = nu / rho - 1

		let Ma = (1 + n + (5 / 4) * n2 + (5 / 4) * n3) * (lat - lat0)
		let Mb = (3 * n + 3 * n * n + (21 / 8) * n3) * sin(lat - lat0) * cos(lat + lat0)
		let Mc = ((15 / 8) * n2 + (15 / 8) * n3) * sin(2 * (lat - lat0)) * cos(2 * (lat + lat0))
		let Md = (35 / 24) * n3 * sin(3 * (lat - lat0)) * cos(3 * (lat + lat0))
		let M = b * F0 * (Ma - Mb + Mc - Md)              // meridional arc

		let cos3lat = cosLat * cosLat * cosLat
		let cos5lat = cos3lat * cosLat * cosLat
		let tan2lat = tan(lat) * tan(lat)
		let tan4lat = tan2lat * tan2lat

		let I = M + N0
		let II = (nu / 2) * sinLat * cosLat
		let III = (nu / 24) * sinLat * cos3lat * (5 - tan2lat + 9 * eta2)
		let IIIA = (nu / 720) * sinLat * cos5lat * (61 - 58 * tan2lat + tan4lat)
		let IV = nu * cosLat
		let V = (nu/6)*cos3lat*(nu/rho-tan2lat);
		let VI = (nu/120) * cos5lat * (5 - 18*tan2lat + tan4lat + 14*eta2 - 58*tan2lat*eta2);

		let dLon = lon - lon0
		let dLon2 = dLon * dLon
		let dLon3 = dLon2 * dLon
		let dLon4 = dLon3 * dLon
		let dLon5 = dLon4 * dLon
		let dLon6 = dLon5 * dLon

		northing = Int(I + II * dLon2 + III * dLon4 + IIIA * dLon6)
		easting = Int(E0 + IV * dLon + V * dLon3 + VI * dLon5)



		// get the 100km-grid indices
		let easting100k = floor(Double(easting) / 100000)
		let northing100k = floor(Double(northing)/100000)

		// Outside of the National Grid.
		guard
			easting100k >= 0,
			easting100k <= 6,
			northing100k >= 0,
			northing100k <= 12
		else {
			return nil
		}

		let eastingLetterDouble = (19 - northing100k) - ((19 - northing100k).truncatingRemainder(dividingBy: 5)) + floor((easting100k + 10) / 5)
		let northingLetterDouble = ((19 - northing100k) * 5).truncatingRemainder(dividingBy: 25) + easting100k.truncatingRemainder(dividingBy: 5)

		var eastingLetterValue = UInt32(floor(eastingLetterDouble))
		var northingLetterValue = UInt32(floor(northingLetterDouble))

		// compensate for skipped 'I' and build grid letter-pairs
		if eastingLetterValue > 7 { eastingLetterValue += 1 }
		if northingLetterValue > 7 { northingLetterValue += 1 }

		guard
			let A = UnicodeScalar("A"),
			let eastingLetter = UnicodeScalar(A.value + eastingLetterValue),
			let northingLetter = UnicodeScalar(A.value + northingLetterValue)
		else {
			return nil
		}

		gridSquareLetters = String(eastingLetter) + String(northingLetter)
	}
}

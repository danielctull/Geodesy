
import Foundation

public struct OSGridReference: GridReference {
    public let region: String
    public let easting: Int
    public let northing: Int
    public let accuracy: Int
}

extension OSGridReference {

    public init?(coordinate inCoordinate: Coordinate) {

        var coordinate = inCoordinate

        // If the coordinate is not in the OSGB36 system,
        // let's try to convert it.
        if coordinate.datum != .osgb36 {
            coordinate = coordinate.convert(to: .osgb36)
        }

        // Do a sanity check here to make sure the
        // coordinate is now in the OSGB36 system.
        guard coordinate.datum == .osgb36 else { return nil }

        accuracy = Int(ceil(coordinate.accuracy))

        let lat = coordinate.latitude.radians
        let lon = coordinate.longitude.radians

        // Airy 1830 major & minor semi-axes
        let a = Ellipsoid.airy1830.semiMajorAxis
        let b = Ellipsoid.airy1830.semiMinorAxis

        // National Grid scale factor on central meridian
        let F0 = 0.9996012717

        // National Grid true origin is 49ºN,2ºW
        let lat0 = Angle.degrees(49).radians
        let lon0 = Angle.degrees(-2).radians

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
        let V = (nu / 6) * cos3lat * (nu / rho - tan2lat)
        let VI = (nu / 120) * cos5lat * (5 - 18 * tan2lat + tan4lat + 14 * eta2 - 58 * tan2lat * eta2)

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
        let northing100k = floor(Double(northing) / 100000)

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

        let A = UnicodeScalar("A")

        guard
            let eastingLetter = UnicodeScalar(A.value + eastingLetterValue),
            let northingLetter = UnicodeScalar(A.value + northingLetterValue)
        else {
            return nil
        }

        region = String(eastingLetter) + String(northingLetter)
    }

    public init?(reference inReference: String) {

        var reference = inReference.uppercased()

        // Remove any extra characters
        let characterSet = CharacterSet.uppercaseLetters.union(.decimalDigits).inverted
        let array = reference.components(separatedBy: characterSet)
        reference = array.joined()

        guard reference.count >= 2 else {
            return nil
        }

        // GRID REGION

        let regionEndIndex = reference.index(reference.startIndex, offsetBy: 2)
        let regionString = reference[..<regionEndIndex]

        let A = UnicodeScalar("A")

        guard
            let eastingCharacter = regionString.first,
            let northingCharacter = regionString.last,
            let eastingLetter = UnicodeScalar(String(eastingCharacter)),
            let northingLetter = UnicodeScalar(String(northingCharacter))
        else {
            return nil
        }

        // get numeric values of letter references, mapping A->0, B->1, C->2, etc:
        var eastingValue = eastingLetter.value - A.value
        var northingValue = northingLetter.value - A.value

        // shuffle down letters after 'I' since 'I' is not used in grid:
        if eastingValue > 7 { eastingValue -= 1 }
        if northingValue > 7 { northingValue -= 1 }

        // convert grid letters into 100km-square indexes from false origin (grid square SV):
        let eastingRegion = Int(((eastingValue - 2) % 5) * 5 + (northingValue % 5))
        let northingRegion = Int((19 - floor(Double(eastingValue / 5)) * 5) - floor(Double(northingValue / 5)))

        // Outside of the National Grid.
        guard
            eastingRegion >= 0,
            eastingRegion <= 6,
            northingRegion >= 0,
            northingRegion <= 12
        else {
            return nil
        }

        // VALUE PART

        let valueString = reference[regionEndIndex...]

        // Make sure we have an even number of values
        guard valueString.count % 2 == 0 else { return nil }

        let length = valueString.count / 2
        let midIndex = valueString.index(valueString.startIndex, offsetBy: length)

        var padding = "50000"
        padding = String(padding[..<padding.index(padding.endIndex, offsetBy: -length)])

        var eastingString = String(valueString[..<midIndex])
        var northingString = String(valueString[midIndex...])

        eastingString = "\(eastingRegion)\(eastingString)\(padding)"
        northingString = "\(northingRegion)\(northingString)\(padding)"

        guard
            let easting = Int(eastingString),
            let northing = Int(northingString)
        else {
            return nil
        }

        self.easting = easting
        self.northing = northing
        self.region = String(regionString)
        self.accuracy = 0
    }

    public var coordinate: Coordinate {

        let E = Double(easting)
        let N = Double(northing)

        // Airy 1830 major & minor semi-axes
        let a = Ellipsoid.airy1830.semiMajorAxis
        let b = Ellipsoid.airy1830.semiMinorAxis

        // National Grid scale factor on central meridian
        let F0 = 0.9996012717

        // National Grid true origin is 49ºN,2ºW
        let lat0 = Angle.degrees(49).radians
        let lon0 = Angle.degrees(-2).radians

        // northing & easting of true origin, metres
        let N0: Double = -100000
        let E0: Double = 400000

        // eccentricity squared
        let e2 = 1 - (b * b) / (a * a)

        let n = (a - b) / (a + b)
        let n2 = n * n
        let n3 = n * n * n

        var lat = lat0
        var M: Double = 0

        repeat {

            lat = (N - N0 - M) / (a * F0) + lat

            let Ma = (1 + n + (5 / 4) * n2 + (5 / 4) * n3) * (lat - lat0)
            let Mb = (3 * n + 3 * n * n + (21 / 8) * n3) * sin(lat - lat0) * cos(lat + lat0)
            let Mc = ((15 / 8) * n2 + (15 / 8) * n3) * sin(2 * (lat - lat0)) * cos(2 * (lat + lat0))
            let Md = (35 / 24) * n3 * sin(3 * (lat - lat0)) * cos(3 * (lat + lat0))

            // meridional arc
            M = b * F0 * (Ma - Mb + Mc - Md)

        } while (N - N0 - M >= 0.00001) // ie until < 0.01mm

        let cosLat = cos(lat)
        let sinLat = sin(lat)

        // transverse radius of curvature
        let nu = a * F0 / sqrt(1 - e2 * sinLat * sinLat)

        // meridional radius of curvature
        let rho = a * F0 * (1 - e2) / pow(1 - e2 * sinLat * sinLat, 1.5)

        let eta2 = nu / rho - 1

        let tanLat = tan(lat)
        let tan2lat = tanLat * tanLat
        let tan4lat = tan2lat * tan2lat
        let tan6lat = tan4lat * tan2lat

        let secLat = 1 / cosLat

        let nu3 = nu * nu * nu
        let nu5 = nu3 * nu * nu
        let nu7 = nu5 * nu * nu

        let VII = tanLat / (2 * rho * nu)
        let VIII = tanLat / (24 * rho * nu3) * (5 + 3 * tan2lat + eta2 - 9 * tan2lat * eta2)
        let IX = tanLat / (720 * rho * nu5) * (61 + 90 * tan2lat + 45 * tan4lat)
        let X = secLat / nu
        let XI = secLat / (6 * nu3) * (nu / rho + 2 * tan2lat)
        let XII = secLat / (120 * nu5) * (5 + 28 * tan2lat + 24 * tan4lat)
        let XIIA = secLat / (5040 * nu7) * (61 + 662 * tan2lat + 1320 * tan4lat + 720 * tan6lat)

        let dE = E - E0
        let dE2 = dE * dE
        let dE3 = dE2 * dE
        let dE4 = dE2 * dE2
        let dE5 = dE3 * dE2
        let dE6 = dE4 * dE2
        let dE7 = dE5 * dE2
        lat -= VII * dE2 + VIII * dE4 - IX * dE6
        let lon = lon0 + X * dE - XI * dE3 + XII * dE5 - XIIA * dE7

        return Coordinate(latitude: .radians(lat),
                          longitude: .radians(lon),
                          accuracy: 5,
                          datum: .osgb36)
    }
}

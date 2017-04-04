
public protocol GridReference {
	var region: String { get }
	var easting: Int { get }
	var northing: Int { get }
	var accuracy: Int { get }
}

extension GridReference {

	private func format(value: Int, withNumberOfFigures figures: Int) -> String? {

		// Can only format for less than 6
		guard figures < 6 else {
			return nil
		}

		let rounded = Int(round(Double(value % 100000) / pow(10, 5 - Double(figures))))
		return "\(rounded)"
	}

	public func easting(withNumberOfFigures figures: Int) -> String? {
		return format(value: easting, withNumberOfFigures: figures)
	}

	public func northing(withNumberOfFigures figures: Int) -> String? {
		return format(value: northing, withNumberOfFigures: figures)
	}
}


// Some project wide global helper functions.

func radians(from degrees: Double) -> Double {
	return degrees / 180 * .pi
}

func degrees(from radians: Double) -> Double {
	return radians * 180 / .pi
}

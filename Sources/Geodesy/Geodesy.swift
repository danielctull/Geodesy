
// Some project wide global helper functions.

func radians(from degrees: Double) -> Double {
	degrees / 180 * .pi
}

func degrees(from radians: Double) -> Double {
    radians * 180 / .pi
}


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

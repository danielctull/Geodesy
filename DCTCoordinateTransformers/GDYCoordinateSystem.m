//
//  GDYCoordinateSystem.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 18.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "GDYCoordinateSystem.h"
#import "GDYCoordinate.h"

@implementation GDYCoordinateSystem

- (id)initWithDatum:(GDYDatum *)datum ellipsoid:(GDYEllipsoid *)ellipsoid {
	self = [self init];
	if (!self) return nil;
	_datum = datum;
	_ellipsoid = ellipsoid;
	return self;
}

+ (instancetype)WGS84CoordinateSystem {
	GDYDatum *datum = [[GDYDatum alloc] initWithType:GDYDatumTypeWGS84];
	GDYEllipsoid *ellipsoid = [GDYEllipsoid WGS84Ellipsoid];
	return [[self alloc] initWithDatum:datum ellipsoid:ellipsoid];
}

+ (instancetype)OSGB36CoordinateSystem {
	GDYDatum *datum = [[GDYDatum alloc] initWithType:GDYDatumTypeOSGB36];
	GDYEllipsoid *ellipsoid = [GDYEllipsoid Airy1830Ellipsoid];
	return [[self alloc] initWithDatum:datum ellipsoid:ellipsoid];
}

- (GDYCoordinate *)convertCoordinate:(GDYCoordinate *)coordinate toSystem:(GDYCoordinateSystem *)newSystem {
	
	if (coordinate.coordinateSystem.datum.type != GDYDatumTypeWGS84 && newSystem.datum.type != GDYDatumTypeWGS84) {
		GDYCoordinateSystem *midSystem = [GDYCoordinateSystem WGS84CoordinateSystem];
		coordinate = [midSystem convertCoordinate:coordinate toSystem:midSystem];
	}

	GDYHelmertDatumTransform *datumTransform;
	if (coordinate.coordinateSystem.datum.type == GDYDatumTypeWGS84)
		datumTransform = [newSystem.datum transformFromWGS84];
	else
		datumTransform = [coordinate.coordinateSystem.datum transformToWGS84];
	
	// -- 1: convert polar to cartesian coordinates (using ellipse 1)
	
	double lat = [self degreesToRadians:coordinate.latitude];
	double lon = [self degreesToRadians:coordinate.longitude];
	
	GDYEllipsoid *e1 = coordinate.coordinateSystem.ellipsoid;
	GDYEllipsoid *e2 = newSystem.ellipsoid;
	
	double a = e1.semiMajorAxis, b = e1.semiMinorAxis;
	
	double sinPhi = sin(lat);
	double cosPhi = cos(lat);
	double sinLambda = sin(lon);
	double cosLambda = cos(lon);
	double H = 24.7;  // for the moment
	
	double eSq = (a*a - b*b) / (a*a);
	double nu = a / sqrt(1 - eSq*sinPhi*sinPhi);
	
	double x1 = (nu+H) * cosPhi * cosLambda;
	double y1 = (nu+H) * cosPhi * sinLambda;
	double z1 = ((1-eSq)*nu + H) * sinPhi;
	
	
	// -- 2: apply helmert transform using appropriate params
	
	double tx = datumTransform.transformX, ty = datumTransform.transformY, tz = datumTransform.transformZ;
	double rx = [self degreesToRadians:(datumTransform.rotateX/3600)];  // normalise seconds to radians
	double ry = [self degreesToRadians:(datumTransform.rotateY/3600)];
	double rz = [self degreesToRadians:(datumTransform.rotateZ/3600)];
	double s1 = datumTransform.scale/1e6 + 1;          // normalise ppm to (s+1)
	
	// apply transform
	double x2 = tx + x1*s1 - y1*rz + z1*ry;
	double y2 = ty + x1*rz + y1*s1 - z1*rx;
	double z2 = tz - x1*ry + y1*rx + z1*s1;
	
	
	// -- 3: convert cartesian to polar coordinates (using ellipse 2)
	
	a = e2.semiMajorAxis, b = e2.semiMinorAxis;
	double precision = 4 / a;  // results accurate to around 4 metres
	
	eSq = (a*a - b*b) / (a*a);
	double p = sqrt(x2*x2 + y2*y2);
	double phi = atan2(z2, p*(1-eSq)), phiP = 2*M_PI;
	while (abs(phi-phiP) > precision) {
		nu = a / sqrt(1 - eSq*sin(phi)*sin(phi));
		phiP = phi;
		phi = atan2(z2 + eSq*nu*sin(phi), p);
	}
	double lambda = atan2(y2, x2);
	H = p/cos(phi) - nu;
	
	double latitude = [self radiansToDegrees:phi];
	double longitude = [self radiansToDegrees:lambda];
	return [[GDYCoordinate alloc] initWithLatitude:latitude
										 longitude:longitude
								  coordinateSystem:newSystem];
	
}

- (double)radiansToDegrees:(double)radians {
	return radians * 180.0 / M_PI;
}

- (double)degreesToRadians:(double)degrees {
	return degrees / 180.0f * M_PI;
}


@end

//
//  DCTOSGridRefCoordinate.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTOSGridRefCoordinate.h"

@implementation DCTOSGridRefCoordinate

- (id)initWithCoordinate:(GDYCoordinate *)coordinate {
	self = [self init];
	if (!self) return nil;
	
	if (coordinate.coordinateSystem.datum.type != GDYDatumTypeOSGB36)
		coordinate = [coordinate convertToCoordinateSystem:[GDYCoordinateSystem OSGB36CoordinateSystem]];
	
	NSAssert(coordinate.coordinateSystem.datum.type == GDYDatumTypeOSGB36, @"Is not GDYDatumTypeOSGB36");
	
	double lat = [self degreesToRadians:coordinate.latitude];
	double lon = [self degreesToRadians:coordinate.longitude];
	
	double a = 6377563.396, b = 6356256.910;          // Airy 1830 major & minor semi-axes
	double F0 = 0.9996012717;                         // NatGrid scale factor on central meridian
	double lat0 = [self degreesToRadians:49], lon0 = [self degreesToRadians:-2];  // NatGrid true origin is 49ºN,2ºW
	double N0 = -100000, E0 = 400000;                 // northing & easting of true origin, metres
	double e2 = 1 - (b*b)/(a*a);                      // eccentricity squared
	double n = (a-b)/(a+b), n2 = n*n, n3 = n*n*n;
	
	double cosLat = cos(lat), sinLat = sin(lat);
	double nu = a*F0/sqrt(1-e2*sinLat*sinLat);              // transverse radius of curvature
	double rho = a*F0*(1-e2)/pow(1-e2*sinLat*sinLat, 1.5);  // meridional radius of curvature
	double eta2 = nu/rho-1;
	
	double Ma = (1 + n + (5/4)*n2 + (5/4)*n3) * (lat-lat0);
	double Mb = (3*n + 3*n*n + (21/8)*n3) * sin(lat-lat0) * cos(lat+lat0);
	double Mc = ((15/8)*n2 + (15/8)*n3) * sin(2*(lat-lat0)) * cos(2*(lat+lat0));
	double Md = (35/24)*n3 * sin(3*(lat-lat0)) * cos(3*(lat+lat0));
	double M = b * F0 * (Ma - Mb + Mc - Md);              // meridional arc
	
	double cos3lat = cosLat*cosLat*cosLat;
	double cos5lat = cos3lat*cosLat*cosLat;
	double tan2lat = tan(lat)*tan(lat);
	double tan4lat = tan2lat*tan2lat;
	
	double I = M + N0;
	double II = (nu/2)*sinLat*cosLat;
	double III = (nu/24)*sinLat*cos3lat*(5-tan2lat+9*eta2);
	double IIIA = (nu/720)*sinLat*cos5lat*(61-58*tan2lat+tan4lat);
	double IV = nu*cosLat;
	double V = (nu/6)*cos3lat*(nu/rho-tan2lat);
	double VI = (nu/120) * cos5lat * (5 - 18*tan2lat + tan4lat + 14*eta2 - 58*tan2lat*eta2);
	
	double dLon = lon-lon0;
	double dLon2 = dLon*dLon, dLon3 = dLon2*dLon, dLon4 = dLon3*dLon, dLon5 = dLon4*dLon, dLon6 = dLon5*dLon;
	
	_northing = I + II*dLon2 + III*dLon4 + IIIA*dLon6;
	_easting = E0 + IV*dLon + V*dLon3 + VI*dLon5;
	
	return self;
}

- (id)initWithGridReference:(NSString *)gridReference {
	
	gridReference = [gridReference uppercaseString];
	NSMutableCharacterSet *characterSet = [NSMutableCharacterSet uppercaseLetterCharacterSet];
	[characterSet formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
	[characterSet invert];
	NSArray *array = [gridReference componentsSeparatedByCharactersInSet:characterSet];
	gridReference = [array componentsJoinedByString:@""];
	
	if (gridReference.length < 2) return 0;
	
	// get numeric values of letter references, mapping A->0, B->1, C->2, etc:
	unichar eastingChar = [gridReference characterAtIndex:0];
	unichar northingChar = [gridReference characterAtIndex:1];
	eastingChar -= 'A';
	northingChar -= 'A';
	
	// shuffle down letters after 'I' since 'I' is not used in grid:
	if (eastingChar > 7) eastingChar--;
	if (northingChar > 7) northingChar--;
	
	// convert grid letters into 100km-square indexes from false origin (grid square SV):
	NSInteger easting = ((eastingChar-2)%5)*5 + (northingChar%5);
	NSInteger northing = (19-floor(eastingChar/5)*5) - floor(northingChar/5);
	if (easting < 0 || easting > 6 || northing < 0 || northing > 12) return 0;
	
	gridReference = [gridReference substringFromIndex:2];
	NSInteger figures = (gridReference.length/2);
	
	NSString *eastingString = [gridReference substringToIndex:figures];
	NSString *northingString = [gridReference substringFromIndex:figures];
	
	NSString *padding = @"50000";
	padding = [padding substringToIndex:(5-figures)];
	
	eastingString = [NSString stringWithFormat:@"%@%@%@", @(easting), eastingString, padding];
	northingString = [NSString stringWithFormat:@"%@%@%@", @(northing), northingString, padding];
	
	return [self initWithEasting:[eastingString integerValue] northing:[northingString integerValue]];
}

- (id)initWithEasting:(NSInteger)easting northing:(NSInteger)northing {
	self = [self init];
	if (!self) return nil;
	_easting = easting;
	_northing = northing;
	return self;
}

- (NSString *)gridReferenceWithNumberOfFigures:(NSInteger)numberOfFigures {
	
	if (numberOfFigures == 0) numberOfFigures = 10;
	
	NSInteger easting = round((self.easting % 100000) / pow(10, 5 - numberOfFigures/2));
	NSInteger northing = round((self.northing % 100000) / pow(10, 5 - numberOfFigures/2));
	return [NSString stringWithFormat:@"%@ %@ %@", self.gridSquareLetters, @(easting), @(northing)];
}

- (NSString *)gridSquareLetters {
	
	// get the 100km-grid indices
	NSInteger easting100k = floor(self.easting/100000);
	NSInteger northing100k = floor(self.northing/100000);
		
	if (easting100k < 0) return nil;
	if (easting100k > 6) return nil;
	if (northing100k < 0) return nil;
	if (northing100k > 12) return nil;
	
	// translate those into numeric equivalents of the grid letters
	unichar eastingLetterValue = (19 - northing100k) - ((19 - northing100k) % 5) + floor((easting100k + 10) / 5);
	unichar northingLetterValue = (((19 - northing100k) * 5) % 25) + (easting100k % 5);
	
	// compensate for skipped 'I' and build grid letter-pairs
	if (eastingLetterValue > 7) eastingLetterValue++;
	if (northingLetterValue > 7) northingLetterValue++;
	
	eastingLetterValue+= 'A';
	northingLetterValue+= 'A';
	
	NSString *eastingLetter = [NSString stringWithFormat:@"%c", eastingLetterValue];
	NSString *northingLetter = [NSString stringWithFormat:@"%c", northingLetterValue];

	return [NSString stringWithFormat:@"%@%@", eastingLetter, northingLetter];
}

- (GDYCoordinate *)convertToCoordinateSystem:(GDYCoordinateSystem *)coordinateSystem {
	
	GDYCoordinate *OSGB36Coordinate = [self OSGB36Coordinate];
	
	if (OSGB36Coordinate.coordinateSystem.datum.type == coordinateSystem.datum.type)
		return OSGB36Coordinate;
	
	return [OSGB36Coordinate convertToCoordinateSystem:coordinateSystem];
}

- (GDYCoordinate *)OSGB36Coordinate {
	
	double E = self.easting;
	double N = self.northing;
	
	double a = 6377563.396, b = 6356256.910;            // Airy 1830 major & minor semi-axes
	double F0 = 0.9996012717;                           // NatGrid scale factor on central meridian
	double lat0 = 49*M_PI/180, lon0 = -2*M_PI/180;		// NatGrid true origin
	double N0 = -100000, E0 = 400000;                   // northing & easting of true origin, metres
	double e2 = 1 - (b*b)/(a*a);                        // eccentricity squared
	double n = (a-b)/(a+b), n2 = n*n, n3 = n*n*n;
	
	double lat=lat0, M=0;
	do {
		lat = (N-N0-M)/(a*F0) + lat;
		
		double Ma = (1 + n + (5/4)*n2 + (5/4)*n3) * (lat-lat0);
		double Mb = (3*n + 3*n*n + (21/8)*n3) * sin(lat-lat0) * cos(lat+lat0);
		double Mc = ((15/8)*n2 + (15/8)*n3) * sin(2*(lat-lat0)) * cos(2*(lat+lat0));
		double Md = (35/24)*n3 * sin(3*(lat-lat0)) * cos(3*(lat+lat0));
		M = b * F0 * (Ma - Mb + Mc - Md);                // meridional arc
		
	} while (N-N0-M >= 0.00001);  // ie until < 0.01mm
	
	double cosLat = cos(lat), sinLat = sin(lat);
	double nu = a*F0/sqrt(1-e2*sinLat*sinLat);              // transverse radius of curvature
	double rho = a*F0*(1-e2)/pow(1-e2*sinLat*sinLat, 1.5);  // meridional radius of curvature
	double eta2 = nu/rho-1;
	
	double tanLat = tan(lat);
	double tan2lat = tanLat*tanLat, tan4lat = tan2lat*tan2lat, tan6lat = tan4lat*tan2lat;
	double secLat = 1/cosLat;
	double nu3 = nu*nu*nu, nu5 = nu3*nu*nu, nu7 = nu5*nu*nu;
	double VII = tanLat/(2*rho*nu);
	double VIII = tanLat/(24*rho*nu3)*(5+3*tan2lat+eta2-9*tan2lat*eta2);
	double IX = tanLat/(720*rho*nu5)*(61+90*tan2lat+45*tan4lat);
	double X = secLat/nu;
	double XI = secLat/(6*nu3)*(nu/rho+2*tan2lat);
	double XII = secLat/(120*nu5)*(5+28*tan2lat+24*tan4lat);
	double XIIA = secLat/(5040*nu7)*(61+662*tan2lat+1320*tan4lat+720*tan6lat);
	
	double dE = (E-E0), dE2 = dE*dE, dE3 = dE2*dE, dE4 = dE2*dE2, dE5 = dE3*dE2, dE6 = dE4*dE2, dE7 = dE5*dE2;
	lat = lat - VII*dE2 + VIII*dE4 - IX*dE6;
	double lon = lon0 + X*dE - XI*dE3 + XII*dE5 - XIIA*dE7;
	
	double latitude = [self radiansToDegrees:lat];
	double longitude = [self radiansToDegrees:lon];
	GDYCoordinateSystem *system = [GDYCoordinateSystem OSGB36CoordinateSystem];
	return [[GDYCoordinate alloc] initWithLatitude:latitude longitude:longitude coordinateSystem:system];
}

- (double)radiansToDegrees:(double)radians {
	return radians * 180.0 / M_PI;
}

- (double)degreesToRadians:(double)degrees {
	return degrees / 180.0f * M_PI;
}

@end

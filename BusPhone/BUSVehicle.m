//
//  BUSVehicle.m
//  BusPhone
//
//  Created by Izzy Fraimow on 6/8/13.
//  Copyright (c) 2013 Izzy Fraimow. All rights reserved.
//

#import "BUSVehicle.h"

@interface BUSVehicle ()

@property (nonatomic, strong, readwrite) NSString *UID;
@property (nonatomic, strong, readwrite) NSString *provider;
@property (nonatomic, assign, readwrite) BUSVehicleType vehicleType;
@property (nonatomic, strong, readwrite) NSString *vehicleID;
@property (nonatomic, strong, readwrite) NSString *previousStop;
@property (nonatomic, strong, readwrite) NSString *nextStop;
@property (nonatomic, strong, readwrite) NSString *coach;
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *routeID;
@property (nonatomic, strong, readwrite) NSString *route;
@property (nonatomic, strong, readwrite) NSString *tripID;
@property (nonatomic, strong, readwrite) NSString *destination;
@property (nonatomic, strong, readwrite) NSString *color;
@property (nonatomic, strong, readwrite) NSNumber *speed;
@property (nonatomic, strong, readwrite) NSNumber *speedKmh;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong, readwrite) NSNumber *heading;
@property (nonatomic, assign, readwrite) BOOL inService; // XXX
@property (nonatomic, strong, readwrite) NSDate *timestamp;
@property (nonatomic, strong, readwrite) NSNumber *age;

@property (nonatomic, assign, readwrite) CLLocationDegrees lat;
@property (nonatomic, assign, readwrite) CLLocationDegrees lon;

@end

@implementation BUSVehicle

+ (instancetype)vehicleWithJSONDict:(NSDictionary *)JSONDict; {
	BUSVehicle *newVehicle = [[[self class] alloc] initWithJSONDict:JSONDict];
	return newVehicle;
}

- (instancetype)initWithJSONDict:(NSDictionary *)JSONDict; {
	self = [super init];
	if(!self) return nil;
	
	[self setValuesWithJSONDict:JSONDict];
	
	return self;
}

- (void)setValuesWithVehicle:(BUSVehicle *)otherVehicle; {
	self.UID = otherVehicle.UID;
	self.provider = otherVehicle.provider;
	self.vehicleType = otherVehicle.vehicleType;
	self.vehicleID = otherVehicle.vehicleID;
	self.previousStop = otherVehicle.previousStop;
	self.nextStop = otherVehicle.nextStop;
	self.coach = otherVehicle.coach;
	self.name = otherVehicle.name;
	self.routeID = otherVehicle.routeID;
	self.route = otherVehicle.route;
	self.tripID = otherVehicle.tripID;
	self.destination = otherVehicle.destination;
	self.color = otherVehicle.color;
	self.speed = otherVehicle.speed;
	self.speedKmh = otherVehicle.speedKmh;
	//self.heading = otherVehicle.heading;
	self.inService = otherVehicle.inService; // XXX
	self.timestamp = otherVehicle.timestamp;
	self.age = otherVehicle.age;
	
	self.coordinate = otherVehicle.coordinate;
}

- (void)setValuesWithJSONDict:(NSDictionary *)JSONDict; {
	self.UID = JSONDict[@"uid"];
	self.provider = JSONDict[@"provider"];
	
	NSString *type = JSONDict[@"vehicleType"];
	if([type isEqualToString:@"bus"]) {
		self.vehicleType = BUSVehicleTypeBus;
	} else if([type isEqualToString:@"ferry"]) {
		self.vehicleType = BUSVehicleTypeFerry;
	} else if([type isEqualToString:@"streetcar"]) {
		self.vehicleType = BUSVehicleTypeStreetCar;
	} else if([type isEqualToString:@"train"]) {
		self.vehicleType = BUSVehicleTypeTrain;
	} else if([type isEqualToString:@"lrv"]) {
		self.vehicleType = BUSVehicleTypeLunarRover;
	} else {
		self.vehicleType = BUSVehicleTypeUnknown;
	}
	
	self.vehicleID = JSONDict[@"vehicleId"];
	self.previousStop = JSONDict[@"prevStop"];
	self.nextStop = JSONDict[@"nextStop"];
	self.coach = JSONDict[@"coach"];
	self.name = JSONDict[@"name"];
	self.routeID = JSONDict[@"routeId"];
	self.route = JSONDict[@"route"];
	self.tripID = JSONDict[@"tripId"];
	self.destination = JSONDict[@"destination"];
	self.color = JSONDict[@"color"];
	NSString *speedString = JSONDict[@"speed"];
	self.speed = speedString ? [NSDecimalNumber decimalNumberWithString:speedString] : nil;
	//self.speedKmh = JSONDict[@"speedKmh"]? [numberFormatter numberFromString:JSONDict[@"speedKmh"]] : nil;
	self.coordinate = CLLocationCoordinate2DMake([JSONDict[@"lat"] floatValue], [JSONDict[@"lon"] floatValue]);
	self.heading = JSONDict[@"heading"];
	self.inService = [JSONDict[@"inService"] boolValue];
	//	JSONDict[@"timestamp"];
	NSString *ageString = JSONDict[@"age"];
	self.age = ageString ? [NSDecimalNumber decimalNumberWithString:ageString] : nil;
}

- (NSString *)title; {
	return self.route;
}

- (NSString *)subtitle; {
	return [NSString stringWithFormat:@"%@", self.destination];
}

- (NSUInteger)hash; {
	return [self.UID hash];
}

- (BOOL)isEqual:(id)object; {
	if(![object isKindOfClass:[BUSVehicle class]]) return NO;
	return [self.UID isEqualToString:((BUSVehicle *)object).UID];
}

@end

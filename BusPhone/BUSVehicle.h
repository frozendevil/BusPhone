//
//  BUSVehicle.h
//  BusPhone
//
//  Created by Izzy Fraimow on 6/8/13.
//  Copyright (c) 2013 Izzy Fraimow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, BUSVehicleType) {
	BUSVehicleTypeBus,
	BUSVehicleTypeFerry,
	BUSVehicleTypeStreetCar,
	BUSVehicleTypeTrain,
	BUSVehicleTypeLunarRover,
	BUSVehicleTypeUnknown
};

@interface BUSVehicle : NSObject <MKAnnotation>

+ (instancetype)vehicleWithJSONDict:(NSDictionary *)JSONDict;
- (instancetype)initWithJSONDict:(NSDictionary *)JSONDict;
- (void)setValuesWithVehicle:(BUSVehicle *)otherVehicle;
- (void)setValuesWithJSONDict:(NSDictionary *)JSONDict;

@property (nonatomic, strong, readonly) NSString *UID;
@property (nonatomic, strong, readonly) NSString *provider;
@property (nonatomic, assign, readonly) BUSVehicleType vehicleType;
@property (nonatomic, strong, readonly) NSString *vehicleID;
@property (nonatomic, strong, readonly) NSString *previousStop;
@property (nonatomic, strong, readonly) NSString *nextStop;
@property (nonatomic, strong, readonly) NSString *coach;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *routeID;
@property (nonatomic, strong, readonly) NSString *route;
@property (nonatomic, strong, readonly) NSString *tripID;
@property (nonatomic, strong, readonly) NSString *destination;
@property (nonatomic, strong, readonly) NSString *color;
@property (nonatomic, strong, readonly) NSNumber *speed;
@property (nonatomic, strong, readonly) NSNumber *speedKmh;
@property (nonatomic, strong, readonly) NSNumber *heading;
@property (nonatomic, assign, readonly) BOOL inService; // XXX
@property (nonatomic, strong, readonly) NSDate *timestamp;
@property (nonatomic, strong, readonly) NSNumber *age;

@end

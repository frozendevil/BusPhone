//
//  BUSViewController.m
//  BusPhone
//
//  Created by Izzy Fraimow on 6/8/13.
//  Copyright (c) 2013 Izzy Fraimow. All rights reserved.
//

#import "BUSViewController.h"
#import "SRWebSocket.h"
#import "BUSVehicle.h"
#import "BUSVehicleAnnotationView.h"
#import "BUSEventManager.h"
#import <MapKit/MapKit.h>

@interface BUSViewController () <MKMapViewDelegate, SRWebSocketDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *map;
@property (nonatomic, strong) BUSEventManager *socketManager;
@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, strong) NSMutableArray *vehicles;

@end

@implementation BUSViewController

- (void)dealloc; {
	[self.webSocket close];
}

- (void)viewDidLoad; {
    [super viewDidLoad];
		
	self.socketManager = [BUSEventManager new];
	[self.socketManager start];
	
	self.vehicles = [NSMutableArray array];
	
	NSURL *busDroneURL = [NSURL URLWithString:@"ws://busdrone.com:28737/"];
	self.webSocket = [[SRWebSocket alloc] initWithURL:busDroneURL];
	self.webSocket.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated; {
	CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(47.6204,  -122.3491);
	MKCoordinateSpan startSpan = MKCoordinateSpanMake(.07, .07);
	MKCoordinateRegion startRegion = MKCoordinateRegionMake(startCoord, startSpan);
	[self.map setRegion:startRegion animated:NO];
	
	[self.webSocket open];
}

- (void)didReceiveMemoryWarning; {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SRWebSocketDelegate

static NSString * const BUSSocketEventTypeInit = @"init";
static NSString * const BUSSocketEventTypeUpdateVehicle = @"update_vehicle";
static NSString * const BUSSocketEventTypeRemoveVehicle = @"remove_vehicle";

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message; {
	NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;
	NSDictionary *busEventDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	if(!busEventDict) {
		NSLog(@"JSON parsing error: %@", error);
	}
	
	NSString *eventType = busEventDict[@"type"];
	
	if([eventType isEqualToString:BUSSocketEventTypeInit]) {
		[self createVehiclesWithJSONArray:busEventDict[@"vehicles"]];
	} else if([eventType isEqualToString:BUSSocketEventTypeUpdateVehicle]) {
		[self updateVehicleWithJSONDict:busEventDict[@"vehicle"]];
	} else if([eventType isEqualToString:BUSSocketEventTypeUpdateVehicle]) {
		[self removeVehicleWithJSONDict:busEventDict[@"vehicle"]];
	}
}

- (void)createVehiclesWithJSONArray:(NSArray *)JSONArray; {
	[self.map removeAnnotations:self.map.annotations];
	
	for(NSDictionary *vehicleDict in JSONArray) {
		BUSVehicle *newVehicle = [[BUSVehicle alloc] initWithJSONDict:vehicleDict];
		[self.map addAnnotation:newVehicle];
	}
}

- (void)updateVehicleWithJSONDict:(NSDictionary *)JSONDict; {
	BUSVehicle *newVehicle = [[BUSVehicle alloc] initWithJSONDict:JSONDict]; //make a partial object to grab a full one from the array
	NSUInteger index = [self.map.annotations indexOfObject:newVehicle];
	if(index == NSNotFound) return;
	
	[UIView animateWithDuration:0.25 animations:^{
		BUSVehicle *annotation = self.map.annotations[index];
		[annotation setValuesWithJSONDict:JSONDict];
	}];
}

- (void)removeVehicleWithJSONDict:(NSDictionary *)JSONDict; {
	BUSVehicle *newVehicle = [[BUSVehicle alloc] initWithJSONDict:JSONDict];
	[self.map removeAnnotation:newVehicle];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation; {
	if([annotation isKindOfClass:[MKUserLocation class]]) return nil;
	
	BUSVehicleAnnotationView *annotationView = (BUSVehicleAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
    if (!annotationView) {
        annotationView = [[BUSVehicleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
        annotationView.canShowCallout = YES;
        annotationView.draggable = NO;
    } else {
		[annotationView setAnnotation:annotation];
	}
	
	return annotationView;
}

@end

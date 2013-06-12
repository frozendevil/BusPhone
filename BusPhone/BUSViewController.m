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

@interface BUSViewController () <MKMapViewDelegate, BUSEventManagerDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *map;
@property (nonatomic, strong) BUSEventManager *eventManager;

@end

@implementation BUSViewController

- (void)viewDidLoad; {
    [super viewDidLoad];
		
	self.eventManager = [BUSEventManager new];
	self.eventManager.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated; {
	CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(47.6204,  -122.3491);
	MKCoordinateSpan startSpan = MKCoordinateSpanMake(.07, .07);
	MKCoordinateRegion startRegion = MKCoordinateRegionMake(startCoord, startSpan);
	[self.map setRegion:startRegion animated:NO];
	
	[self.eventManager start];
}

- (void)viewDidDisappear:(BOOL)animated; {
	[self.eventManager stop];
}

#pragma mark - BUSEventManagerDelegate

- (void)eventManager:(BUSEventManager *)manager didReceiveNewVehicles:(NSArray *)vehicles; {
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		[self.map removeAnnotations:self.map.annotations];
		[self.map addAnnotations:vehicles];
	}];
}

- (void)eventManager:(BUSEventManager *)manager didUpdateVehicles:(NSArray *)vehicles; {
	[vehicles enumerateObjectsUsingBlock:^(BUSVehicle *newVehicle, NSUInteger idx, BOOL *stop) {
		NSUInteger index = [self.map.annotations indexOfObject:newVehicle];
		if(index == NSNotFound) return;
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[UIView animateWithDuration:0.25 animations:^{
				BUSVehicle *annotation = self.map.annotations[index];
				[annotation setValuesWithVehicle:newVehicle];
			}];
		}];
	}];
}

- (void)eventManager:(BUSEventManager *)manager didRemoveVehicles:(NSArray *)vehicles; {
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		[self.map removeAnnotations:vehicles];
	}];
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

//
//  ViewController.m
//  FindATestingCenter
//
//  Created by Edan Lichtenstein on 2/21/15.
//  Copyright (c) 2015 CodeForRVA. All rights reserved.
//

#import "ViewController.h"
#define METERS_PER_MILE 1609.344

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startLocationManager];
    self.mapView.showsUserLocation = YES;
}

-(void)startLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization];
}


- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}

- (void)viewWillAppear:(BOOL)animated {
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 37.5333;
    zoomLocation.longitude= -77.4667;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 5*METERS_PER_MILE, 5*METERS_PER_MILE);

    [self.mapView setRegion:viewRegion animated:YES];
    
    NSLog(@"%@", [self deviceLocation]);
}



@end

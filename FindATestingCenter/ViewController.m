//
//  ViewController.m
//  FindATestingCenter
//
//  Created by Edan Lichtenstein on 2/21/15.
//  Copyright (c) 2015 CodeForRVA. All rights reserved.
//


//  API to hit - https://brigades.opendatanetwork.com/resource/rj82-n357.json



#import "ViewController.h"
#import "MapViewAnnotation.h"
#import "ClinicLocationProvider.h"
#import "MBProgressHUD.h"
#define METERS_PER_MILE 1609.344


@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *fields;
@property (nonatomic, strong) NSMutableArray *currentRow;
@property (nonatomic, strong) NSMutableArray *outputArray;
@property BOOL readingTopLine;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.showsUserLocation = YES;
    
    [self startLocationManager];
    
    [self fetchData];
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



- (void)viewWillAppear:(BOOL)animated {
    CLLocationCoordinate2D zoomLocation;
    
    if (self.locationManager.location.coordinate.latitude == 0.0) {
        //If location not enabled, zoom in on Daily Planet location
        zoomLocation.latitude = 37.5476;
        zoomLocation.longitude = -77.4476;
    } else {
        zoomLocation.latitude = self.locationManager.location.coordinate.latitude;
        zoomLocation.longitude= self.locationManager.location.coordinate.longitude;
    }
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 8*METERS_PER_MILE, 8*METERS_PER_MILE);

    [self.mapView setRegion:viewRegion animated:YES];
    [self.mapView regionThatFits:viewRegion];
    
    NSLog(@"%@", [self deviceLocation]);
}


- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"Device location - latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}


-(void)fetchData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading clinic information";
  
    
    [ClinicLocationProvider requestClinicsWithCompletionHandler:^(NSArray *clinics, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }

        [self.mapView addAnnotations:[self createAnnotations:clinics]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}




#pragma mark - Map Methods

- (NSMutableArray *)createAnnotations:(NSArray *)clinicArray {
    
    NSMutableArray *annotationsArray = [[NSMutableArray alloc] init];
    
    for(ClinicDataObject *clinic in clinicArray) {
        
        NSString *name = clinic.name;
        CGFloat latitude = clinic.latitude;
        CGFloat longitude = clinic.longitude;
        
        //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D coord;
        coord.latitude = latitude;
        coord.longitude = longitude;
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithName:name AndCoordinate:coord];
        [annotationsArray addObject:annotation];
        
        //  NSLog(@"Title: %@, Latitude: %@, Longitude %@", title, latitude, longitude);
    }
    return annotationsArray;
}

@end

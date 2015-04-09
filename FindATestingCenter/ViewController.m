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
    
    [self.mapView addAnnotations:[self createAnnotations]];
    
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
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}


-(void)fetchData {
    
    [ClinicLocationProvider requestClinicsWithCompletionHandler:^(NSArray *clinics, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}


#pragma mark - CSV Parsing

- (NSMutableArray *)createAnnotations {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"locations" ofType:@"csv"];
    NSURL *url =  [NSURL fileURLWithPath:filePath];
    CHCSVParser *parser = [[CHCSVParser alloc]initWithContentsOfCSVURL:url];
    parser.delegate = self;
    [parser parse];
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    for(NSArray *row in self.outputArray) {
        
        NSString *title = [row objectAtIndex:0];
        NSNumber *latitude = [row objectAtIndex:11];
        NSNumber *longitude = [row objectAtIndex:12];
        
        //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D coord;
        coord.latitude = latitude.doubleValue;
        coord.longitude = longitude.doubleValue;
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:title AndCoordinate:coord];
        [annotations addObject:annotation];
        
        NSLog(@"Title: %@, Latitude: %@, Longitude %@", title, latitude, longitude);
    }
    return annotations;
}



#pragma mark - Parser

- (void)parserDidBeginDocument:(CHCSVParser *)parser {
    self.fields = [[NSMutableArray alloc] init];
    self.currentRow = [[NSMutableArray alloc] init];
    self.outputArray = [[NSMutableArray alloc] init];
}


- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    if (recordNumber == 1) {
        self.fields = [[NSMutableArray alloc]init];
        self.readingTopLine = YES;
    }
    else {
        self.currentRow = [[NSMutableArray alloc]init];
        self.readingTopLine = NO;
    }
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    
    if (!self.readingTopLine){
        [self.currentRow addObject:field];
    }
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    if (!self.readingTopLine){
        [self.outputArray addObject:self.currentRow];
    }
    self.currentRow = nil;
}

- (void)parserDidEndDocument:(CHCSVParser *)parser {
}
- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Parser failed with error: %@ %@", [error localizedDescription], [error userInfo]);
    self.outputArray = nil;
}

@end

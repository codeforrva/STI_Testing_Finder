//
//  ViewController.m
//  FindATestingCenter
//
//  Created by Edan Lichtenstein on 2/21/15.
//  Copyright (c) 2015 CodeForRVA. All rights reserved.
//

#import "ViewController.h"
#import "MapViewAnnotation.h"
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
    
    [self startLocationManager];
    self.mapView.showsUserLocation = YES;
    
    [self.mapView addAnnotations:[self createAnnotations]];
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


#pragma mark - CSV Parsing

- (NSMutableArray *)createAnnotations {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"locations" ofType:@"csv"];
    NSURL *url =  [NSURL fileURLWithPath:filePath];
    CHCSVParser *parser = [[CHCSVParser alloc]initWithContentsOfCSVURL:url];
    parser.delegate = self;
    [parser parse];
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    for(NSArray *row in self.outputArray) {
        
        NSString *title = [row objectAtIndex:1];
        NSNumber *latitude = [row objectAtIndex:12];
        NSNumber *longitude = [row objectAtIndex:13];
        
        //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D coord;
        coord.latitude = latitude.doubleValue;
        coord.longitude = longitude.doubleValue;
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:title AndCoordinate:coord];
        [annotations addObject:annotation];
    }
    NSLog(@"annotations: %@", annotations);
    return annotations;
}



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
     NSLog(@"Parser ended: %@", self.outputArray);
}
- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Parser failed with error: %@ %@", [error localizedDescription], [error userInfo]);
    self.outputArray = nil;
}

@end

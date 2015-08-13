//
//  ViewController.m
//  FindATestingCenter
//
//  Created by Edan Lichtenstein on 2/21/15.
//  Copyright (c) 2015 CodeForRVA. All rights reserved.
//


//  API to hit - https://brigades.opendatanetwork.com/resource/rj82-n357.json



#import "ViewController.h"
#import "ListViewController.h"
#import "MapViewController.h"
#import "MapViewAnnotation.h"
#import "ClinicLocationProvider.h"
#import "MBProgressHUD.h"
#define METERS_PER_MILE 1609.344


@interface ViewController ()

@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *segmentedViewControllers;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) IBOutlet UIView *listContentView;
@property (nonatomic, strong) IBOutlet UIView *mapContentView;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.showsUserLocation = YES;

    [self startLocationManager];
    [self fetchData];
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



#pragma mark - Segment control
// https://github.com/rajohns08/codingdiscovery/tree/master/2015.03.01%20-%20ContainerSwap/ContainerSwap

- (IBAction)didChangeSegmentControl:(UISegmentedControl *)sender {

    UISegmentedControl *segment = sender;
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            self.listContentView.hidden = NO;
            break;
        case 1:
            self.listContentView.hidden = YES;
            break;
        default:
            break;
    }

}



#pragma mark - Map Methods


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

-(void)startLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization];
}


- (NSMutableArray *)createAnnotations:(NSArray *)clinicArray {
    
    NSMutableArray *annotationsArray = [[NSMutableArray alloc] init];
    
    for(ClinicDataObject *clinic in clinicArray) {
        
        NSString *name = clinic.name;
        NSString *subtitle = clinic.servicesOffered;
        CGFloat latitude = clinic.latitude;
        CGFloat longitude = clinic.longitude;
        
        //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D coord;
        coord.latitude = latitude;
        coord.longitude = longitude;
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithName:name subtitle:subtitle AndCoordinate:coord];
        [annotationsArray addObject:annotation];
        
        //  NSLog(@"Title: %@, Latitude: %@, Longitude %@", title, latitude, longitude);
    }
    return annotationsArray;
}


#pragma mark - Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    for (UIViewController * viewController in self.segmentedViewControllers) {
        [viewController didReceiveMemoryWarning];
    }
}
@end

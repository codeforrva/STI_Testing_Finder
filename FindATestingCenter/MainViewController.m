//
//  ViewController.m
//  FindATestingCenter
//
//  Created by Edan Lichtenstein on 2/21/15.
//  Copyright (c) 2015 CodeForRVA. All rights reserved.
//


//  API to hit - https://brigades.opendatanetwork.com/resource/rj82-n357.json



#import "MainViewController.h"
#import "ListViewController.h"
#import "MapViewController.h"
#import "ClinicLocationProvider.h"
#import "MBProgressHUD.h"
#define METERS_PER_MILE 1609.344


@interface MainViewController ()

@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *segmentedViewControllers;
@property (nonatomic, strong) IBOutlet UIView *listContentView;
@property (nonatomic, strong) IBOutlet UIView *mapContentView;

@property (nonatomic, strong) MapViewController *mapViewController;
@property (nonatomic, strong) ListViewController *listViewController;



@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLocationManager];
    self.mapViewController =[self.childViewControllers objectAtIndex:1];//[self.storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
    self.listViewController =[self.childViewControllers objectAtIndex:0];// [self.storyboard instantiateViewControllerWithIdentifier:@"ListVC"];

    self.mapViewController.view.frame = self.mapContentView.bounds;
    [self.mapContentView addSubview:self.mapViewController.view];
    self.listViewController.view.frame = self.listContentView.bounds;
    [self.listContentView addSubview:self.listViewController.view];
    
    NSLog(@"map v: %@", self.childViewControllers);
    
    [self findAndSetLocation];
    [self fetchData];
}




- (void)viewWillAppear:(BOOL)animated {
    

}

- (void)findAndSetLocation {
    CLLocationCoordinate2D zoomLocation;
    
    if (![CLLocationManager locationServicesEnabled]) {
    //If location not enabled, zoom in on Daily Planet location
        zoomLocation.latitude = 37.5476;
        zoomLocation.longitude = -77.4476;
    } else {
        zoomLocation.latitude = self.locationManager.location.coordinate.latitude;
        zoomLocation.longitude= self.locationManager.location.coordinate.longitude;
    }
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 8*METERS_PER_MILE, 8*METERS_PER_MILE);
    [self.mapViewController setMapFocusRegion:viewRegion];
}


- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"Device location - latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}



#pragma mark - Segment control
//http://codingdiscovery.blogspot.com/2015/03/swap-viewcontrollers-with-segmented.html


- (IBAction)didChangeSegmentControl:(UISegmentedControl *)sender {

    UISegmentedControl *segment = sender;
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            self.mapContentView.hidden = NO;
            break;
        case 1:
            self.mapContentView.hidden = YES;
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
        
      //  [self.mapViewController.mapView addAnnotations:[self createAnnotations:clinics]];
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


//- (NSMutableArray *)createAnnotations:(NSArray *)clinicArray {
//    
//    NSMutableArray *annotationsArray = [[NSMutableArray alloc] init];
//    
//    for(ClinicDataObject *clinic in clinicArray) {
//        
//        NSString *name = clinic.name;
//        NSString *subtitle = clinic.servicesOffered;
//        CGFloat latitude = clinic.latitude;
//        CGFloat longitude = clinic.longitude;
//        
//        //Create coordinates from the latitude and longitude values
//        CLLocationCoordinate2D coord;
//        coord.latitude = latitude;
//        coord.longitude = longitude;
//        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithName:name subtitle:subtitle AndCoordinate:coord];
//        [annotationsArray addObject:annotation];
//        
//        //  NSLog(@"Title: %@, Latitude: %@, Longitude %@", title, latitude, longitude);
//    }
//    return annotationsArray;
//}


#pragma mark - Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    for (UIViewController * viewController in self.segmentedViewControllers) {
        [viewController didReceiveMemoryWarning];
    }
}
@end

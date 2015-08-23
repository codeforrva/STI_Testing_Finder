//
//  MapViewController.m
//  FindATestingCenter
//
//  Created by Edan Lichtenstein on 6/10/15.
//  Copyright (c) 2015 CodeForRVA. All rights reserved.
//

#import "MapViewController.h"
#import "MapViewAnnotation.h"


@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.showsUserLocation = YES;
    NSLog(@"Map view controller: %@", self);
 
}


- (void)setMapFocusRegion:(MKCoordinateRegion)region {
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
    NSLog(@"Device location - latitude: %f longitude: %f", region.center.latitude,region.center.longitude);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)findAndSetLocation {
//    CLLocationCoordinate2D zoomLocation;
//    
//    zoomLocation.latitude = 37.5476;
//    zoomLocation.longitude = -77.4476;
//    
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 8*1609.344, 8*1609.344);
//    
//     [self setMapFocusRegion:viewRegion];
//}


@end

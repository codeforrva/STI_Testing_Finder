//
//  MapViewController.m
//  FindATestingCenter
//
//  Created by Edan Lichtenstein on 6/10/15.
//  Copyright (c) 2015 CodeForRVA. All rights reserved.
//

#import "MapViewController.h"
#import "MapViewAnnotation.h"
#import "ClinicLocationProvider.h"


@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.showsUserLocation = YES;
}



- (void)setMapFocusRegion:(MKCoordinateRegion)region {
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
    NSLog(@"Device location - latitude: %f longitude: %f", region.center.latitude,region.center.longitude);

}

- (void)addAnnotationsToMap:(NSArray *)clinics{
    [self.mapView addAnnotations:[self createAnnotations:clinics]];

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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

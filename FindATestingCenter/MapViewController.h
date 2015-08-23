//
//  MapViewController.h
//  FindATestingCenter
//
//  Created by Edan Lichtenstein on 6/10/15.
//  Copyright (c) 2015 CodeForRVA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (void)setMapFocusRegion:(MKCoordinateRegion)region;

@end

//
//  MapViewAnnotation.h
//  FindATestingCenter
//
//  Created by Edan Lichtenstein on 2/21/15.
//  Copyright (c) 2015 CodeForRVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic, readonly)CLLocationCoordinate2D coordinate;
-(id) initWithName:(NSString *)name subtitle:(NSString *)subtitle AndCoordinate:(CLLocationCoordinate2D)coordinate;

@end
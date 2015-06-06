//
//  MapViewAnnotation.m
//  FindATestingCenter
//
//  Created by Edan Lichtenstein on 2/21/15.
//  Copyright (c) 2015 CodeForRVA. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

-(id) initWithName:(NSString *)name subtitle:(NSString *)subtitle AndCoordinate:(CLLocationCoordinate2D)coordinate{
    self = [super init];
    _title = name;
    _subtitle = subtitle;
    _coordinate = coordinate;
    return self;
}


@end
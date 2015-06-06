//
//  MapViewAnnotation.m
//  FindATestingCenter
//
//  Created by Edan Lichtenstein on 2/21/15.
//  Copyright (c) 2015 CodeForRVA. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

-(id) initWithName:(NSString *)name AndCoordinate:(CLLocationCoordinate2D)coordinate{
    self = [super init];
    _name = name;
    _coordinate = coordinate;
    return self;
}


@end
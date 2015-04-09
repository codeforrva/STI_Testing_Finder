//
//  ClinicLocationProvider.h
//  FindATestingCenter
//
//  Created by Edan Lichtenstein on 3/11/15.
//  Copyright (c) 2015 CodeForRVA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClinicLocationProvider : NSObject

+ (void)requestClinicsWithCompletionHandler:(void(^)(NSArray* clinics, NSError *error))completionHandler;

@end

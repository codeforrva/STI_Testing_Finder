//
//  ClinicLocationProvider.h
//  FindATestingCenter
//
//  Created by Edan Lichtenstein on 3/11/15.
//  Copyright (c) 2015 CodeForRVA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClinicDataObject : NSObject

@property (nonatomic) NSInteger clinicID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *servicesOffered;
@property (strong, nonatomic) NSString *appointmentHours;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *address1;
@property (strong, nonatomic) NSString *address2;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zipCode;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@end

@interface ClinicLocationProvider : NSObject

+ (void)requestClinicsWithCompletionHandler:(void(^)(NSArray* clinics, NSError *error))completionHandler;

@end



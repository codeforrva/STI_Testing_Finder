//
//  ClinicLocationProvider.m
//  FindATestingCenter
//
//  Created by Edan Lichtenstein on 3/11/15.
//  Copyright (c) 2015 CodeForRVA. All rights reserved.
//

#import "ClinicLocationProvider.h"
#import <AFNetworking.h>

static NSString *brigadeEndpoint = @"https://brigades.opendatanetwork.com/resource/rj82-n357.json";

@implementation ClinicDataObject
@end

@implementation ClinicLocationProvider


+ (void)requestClinicsWithCompletionHandler:(void(^)(NSArray* clinics, NSError *error))completionHandler {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:brigadeEndpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSArray *clinicResponse = [self clinicsObjectsFromResponse:responseDictionary];
        if (completionHandler) {
            completionHandler(clinicResponse,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        if (completionHandler) {
            completionHandler(nil, error);
        }
    }];
}

+ (NSArray *)clinicsObjectsFromResponse:(NSDictionary *)dictionary {
    //NSLog(@"Response Dictionary count: %lu, data: %@", (unsigned long)[dictionary count], dictionary);
    NSMutableArray *clinicsArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *oneClinic in dictionary) {

        ClinicDataObject *clinic = [[ClinicDataObject alloc] init];
        clinic.name = oneClinic[@"name"];
        clinic.phoneNumber = oneClinic[@"phone_number"];
        clinic.address1 = oneClinic[@"address_1"];
        clinic.address2 = oneClinic[@"address_2"];
        clinic.city = oneClinic[@"city"];
        clinic.state = oneClinic[@"state"];
        clinic.zipCode = oneClinic[@"zip_code"];
        clinic.servicesOffered = oneClinic[@"services_offered"];
        clinic.appointmentHours = oneClinic[@"appointments_hours"];
        
        NSDictionary *locationDictionary = oneClinic[@"location"];
        clinic.latitude = [locationDictionary[@"latitude"] floatValue];
        clinic.longitude = [locationDictionary[@"longitude"] floatValue];
        
        [clinicsArray addObject:clinic];
    }
    return clinicsArray;
}


@end

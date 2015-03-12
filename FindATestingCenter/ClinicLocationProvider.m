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

@implementation ClinicLocationProvider

+ (void)fetchClinicsWithCompletionHandler:(void(^)(NSArray* clinics, NSError *error))completionHandler {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:brigadeEndpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSLog(@"Response Dictionary: %@", responseDictionary);
        NSArray *clinics = [self clinicsObjectsFromResponse:responseDictionary];
        if (completionHandler) {
            completionHandler(clinics,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (completionHandler) {
            completionHandler(nil, error);
        }
    }];
}


+ (NSArray *)clinicsObjectsFromResponse:(NSDictionary *)dictionary
{
    NSMutableArray *clinicsArray = [[NSMutableArray alloc] init];
    
    return clinicsArray;
}




@end

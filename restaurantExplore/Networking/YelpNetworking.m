//
//  YelpNetworking.m
//  summerYelpMock
//
//  Created by Jiasheng Miao on 8/26/17.
//  Copyright © 2017 Nick. All rights reserved.
//

#import "YelpNetworking.h"
#import "YelpDataStore.h"



static NSString const * kGrantType = @"client_credentials";
static NSString const * kClient_id = @"UuBJrDWXe084df75tX8yxw";
static NSString const * kClient_secret = @"ypsqzaWa1CxZdTWF5bEVPdaifYGNHTx5RASjKlA71TsR1h9cwyMSlwzVfUYai9sN";
static NSString const * kTokenEndPoint = @"https://api.yelp.com/oauth2/token";

typedef void (^TokenPendingTask)(NSString *token);


@interface YelpNetworking () //so that property is only seen to itself, which is called extension by apple

@property NSString *token;

@end

@implementation YelpNetworking



- (instancetype)init {
    if (self = [super init]){
        [self fetchTokenWithTokenPendingTask
         :nil];
    }
    return self;
} 


+ (YelpNetworking *)sharedInstance {
    static YelpNetworking *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[YelpNetworking alloc] init];
    });
    return _sharedInstance;
}

- (void)fetchTokenWithTokenPendingTask:(TokenPendingTask)tokenPendingTask
{
    NSURL *url = [NSURL URLWithString:kTokenEndPoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"grant_type=%@&client_id=%@&client_secret=%@", kGrantType, kClient_id,kClient_secret];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *postDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        self.token = dict[@"access_token"];
        if (tokenPendingTask) {
            tokenPendingTask(self.token);
        }
    }];
    [postDataTask resume];
}

- (void)fetchRestaurantsBasedOnLocation:(CLLocation *)location term:(NSString *)term parameters:(NSDictionary *)parameters completionBlock:(RestaurantCompletionBlock)completionBlock
{
    TokenPendingTask
    tokenTask = ^(NSString *token){
        NSString *string = [NSString stringWithFormat:@"https://api.yelp.com/v3/businesses/search?term=%@&latitude=%.6f&longitude=%.6f",term, location.coordinate.latitude, location.coordinate.longitude];
        
        for (NSString *key in parameters.allKeys) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,parameters[key]]];
        }

        NSURL *url = [NSURL URLWithString:string];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        [request setHTTPMethod:@"GET"];
        NSString *headerToken = [NSString stringWithFormat:@"Bearer %@",self.token];
        [request addValue:headerToken forHTTPHeaderField:@"Authorization"];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NULL error:nil];
                if (!error) {
//                    completionBlock([YelpDataModel buildDataModelArrayFromDictionaryArray:dict[@"businesses"]]);
                    NSArray<YelpDataModel *> *dataModels = [YelpDataModel buildDataModelArrayFromDictionaryArray:dict[@"businesses"]];
                    [YelpDataStore sharedInstance].dataModels = dataModels;
                    completionBlock(dataModels);
                }
            }
        }];
        [dataTask resume];
    };
    if (self.token) {
        tokenTask(self.token);
    } else {
        [self fetchTokenWithTokenPendingTask:tokenTask];
    }
}

@end




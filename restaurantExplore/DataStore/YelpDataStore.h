//
//  YelpDataStore.h
//  summerYelpMock
//
//  Created by Jiasheng Miao on 9/2/17.
//  Copyright © 2017 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YelpDataModel.h"
@import CoreLocation;
@interface YelpDataStore : NSObject
@property (nonatomic, copy) NSArray <YelpDataModel *> *dataModels;
@property (nonatomic) CLLocation *userLocation;

@property (nonatomic) NSString *priceParameter;
@property (nonatomic) NSMutableSet *selectedCategories;


+ (YelpDataStore *)sharedInstance;
@end


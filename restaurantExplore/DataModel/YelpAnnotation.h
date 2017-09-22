//
//  YelpAnnotation.h
//  summerYelpMock
//
//  Created by Jiasheng Miao on 9/2/17.
//  Copyright © 2017 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "YelpDataModel.h"


@interface YelpAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly) YelpDataModel *dataModel;
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle dataModel:(YelpDataModel *)dataModel;

+ (NSArray <YelpAnnotation *>*)buildAnnotationArrayFromDataArray:(NSArray<YelpDataModel *> *)dataArray;


@end

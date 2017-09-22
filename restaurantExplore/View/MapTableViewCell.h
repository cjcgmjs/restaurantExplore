//
//  MapTableViewCell.h
//  summerYelpMock
//
//  Created by Jiasheng Miao on 9/5/17.
//  Copyright © 2017 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpDataModel.h"
#import "YelpAnnotation.h"


@interface MapTableViewCell : UITableViewCell
-(void) updateBasedOnDataModel: (YelpDataModel *) datamodel;
@end

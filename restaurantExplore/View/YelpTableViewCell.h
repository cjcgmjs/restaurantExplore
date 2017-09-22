//
//  YelpTableViewCell.h
//  summerYelpMock
//
//  Created by Jiasheng Miao on 8/29/17.
//  Copyright © 2017 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YelpDataModel.h"

@interface YelpTableViewCell : UITableViewCell

- (void)updateBasedOnDataModel:(YelpDataModel *)dataModel;

@end


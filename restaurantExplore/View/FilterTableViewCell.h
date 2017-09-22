//
//  FilterTableViewCell.h
//  summerYelpMock
//
//  Created by Jiasheng Miao on 9/12/17.
//  Copyright © 2017 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpFilterDataModel.h"

@interface FilterTableViewCell : UITableViewCell

- (void)updateDataModel:(YelpFilterDataModel *)dataModel;

@end

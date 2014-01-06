<<<<<<< HEAD
#import <UIKit/UIKit.h>

@interface MR_PathCell : UITableViewCell
@property (nonatomic, strong) NSString *model;//这里为了简洁就不引入Model新类，用String先代替
@property(nonatomic, strong) NSDictionary *cellModel;
+ (float)cellHeight;
=======
//
//  MR_PathCell.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface MR_PathCell : UITableViewCell

@property(nonatomic, assign) CGRect cellFrame;
@property(nonatomic, retain) NSDictionary *cellModel;

+ (float)cellHeight;
- (void)refreshPageData;

>>>>>>> branch
@end
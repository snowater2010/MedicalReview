//
//  MR_ClauseDetail.h
//  MedicalReview
//
//  Created by lipeng11 on 13-6-11.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootController.h"

#define CLAUSE_DETAIL_CELL_HEIGHT 70

@interface MR_ClauseDetailCtro : MR_RootController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) NSDictionary *clauseData;
@property(nonatomic, retain) IBOutlet UITableView *tableView;

- (void)reloadData;

@end

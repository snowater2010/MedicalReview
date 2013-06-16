//
//  MR_PathCell.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-23.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//
#import "MR_PathCell.h"

@interface MR_PathCell()

@property(nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) UILabel *descLabel;

@end

@implementation MR_PathCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float cellWidth = self.frame.size.width;
        float cellHeight = [MR_PathCell cellHeight];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight/2)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        [nameLabel release];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight/2, cellWidth, cellHeight/2)];
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:descLabel];
        self.descLabel = descLabel;
        [descLabel release];
    }
    return self;
}

- (void)refreshPageData
{
    NSString *name = [NSString stringWithFormat:@" %@",[_cellModel objectForKey:KEY_nodeName]];
    NSString *total = [_cellModel objectForKey:KEY_totalCount];
    NSString *finish = [_cellModel objectForKey:KEY_finishCount];
    NSString *desc = [NSString stringWithFormat:@" (共%@款，已录入%@款)",total,finish];
    
    _nameLabel.text = name;
    _descLabel.text = desc;
    
    if (total.intValue == finish.intValue) {
        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing.jpg"]];
    }
    else {
        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing1.jpg"]];
    }
}

- (void)dealloc
{
    self.nameLabel = nil;
    self.descLabel = nil;
    [super dealloc];
}

+ (float)cellHeight
{
    return 80;
}

@end

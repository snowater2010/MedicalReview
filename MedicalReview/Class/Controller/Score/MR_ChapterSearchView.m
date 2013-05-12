//
//  MR_ChapterSearchView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-5-12.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ChapterSearchView.h"

@implementation MR_ChapterSearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    float margin = 20;
    
    float name_x = 0.;
    float name_y = 0.;
    float name_w = 100;
    float name_h = rect.size.height;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(name_x, name_y, name_w, name_h)];
    nameLabel.text = @"条款名称：";
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:nameLabel];
    [nameLabel release];
    
    float name2_w = 150;
    float name2_h = 30;
    float name2_x = name_x + name_w;
    float name2_y = (rect.size.height - name2_h) / 2;
    UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(name2_x, name2_y, name2_w, name2_h)];
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:nameField];
    [nameField release];
    
    float scored_w = 200;
    float scored_h = 44;
    float scored_x = name2_x + name2_w + margin;
    float scored_y = (rect.size.height - scored_h) / 2; 
    UISegmentedControl *scoredSeg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"全部", @"已录", @"未录", nil]];
    scoredSeg.frame = CGRectMake(scored_x, scored_y, scored_w, scored_h);
    [scoredSeg setSelectedSegmentIndex:0];
    [scoredSeg addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:scoredSeg];
    [scoredSeg release];
    
    float core_x = scored_x + scored_w + margin;
    float core_y = 0.;
    float core_w = 100;
    float core_h = rect.size.height;
    UILabel *coreLabel = [[UILabel alloc] initWithFrame:CGRectMake(core_x, core_y, core_w, core_h)];
    coreLabel.text = @"核心条款：";
    coreLabel.textAlignment = NSTextAlignmentRight;
    coreLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:coreLabel];
    [coreLabel release];
    
    float core2_w = 100;
    float core2_h = 27;
    float core2_x = core_x + core_w;
    float core2_y = (rect.size.height - core2_h) / 2;
    UISwitch *coreSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(core2_x, core2_y, core2_w, core2_h)];
    [coreSwitch setOn:NO];
    [self addSubview:coreSwitch];
    [coreSwitch release];
    
    float search_w = 60;
    float search_h = 44;
    float search_x = rect.size.width - search_w - 10;
    float search_y = (rect.size.height - search_h) / 2;
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(search_x, search_y, search_w, search_h)];
    searchButton.backgroundColor = [UIColor whiteColor];
    [searchButton setTitle:@"查询" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    searchButton.layer.borderWidth = 1;
    searchButton.layer.borderColor = [[UIColor blackColor] CGColor];
    [self addSubview:searchButton];
    [searchButton release];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)segmentAction:(UISegmentedControl *)seg {
    
    NSInteger Index = seg.selectedSegmentIndex;
    
    switch (Index) {
            
        case 0:
            
            break;
            
        case 1:
            
            break;
            
        case 2:
    
            break;
        default:
            break;
            
    }
}

@end

//
//  MR_ChapterSearchView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-5-12.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ChapterSearchView.h"

@interface MR_ChapterSearchView ()

@property(nonatomic, retain) UITextField *nameField;
@property(nonatomic, retain) UISegmentedControl *scoredSeg;
@property(nonatomic, retain) UISwitch *coreSwitch;
@property(nonatomic, retain) UISwitch *waitSwitch;

@end

@implementation MR_ChapterSearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    float margin = 15;
    float swidthWidth = 80;
    UIFont *font = [UIFont systemFontOfSize:17];
    
    NSString *name = @"条款名称：";
    CGSize nameSize = [name sizeWithFont:font];
    float name_x = margin;
    float name_y = 0.;
    float name_w = nameSize.width;
    float name_h = rect.size.height;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(name_x, name_y, name_w, name_h)];
    nameLabel.text = name;
    nameLabel.font = font;
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
    self.nameField = nameField;
    [nameField release];
    
    float scored_w =180;
    float scored_h = 30;
    float scored_x = name2_x + name2_w + margin;
    float scored_y = (rect.size.height - scored_h) / 2; 
    UISegmentedControl *scoredSeg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"全部", @"已录", @"未录", nil]];
    scoredSeg.frame = CGRectMake(scored_x, scored_y, scored_w, scored_h);
    [scoredSeg setSelectedSegmentIndex:0];
    [self addSubview:scoredSeg];
    self.scoredSeg = scoredSeg;
    [scoredSeg release];
    
    NSString *coreName = @"核心条款：";
    CGSize coreSize = [coreName sizeWithFont:font];
    float core_x = scored_x + scored_w + margin;
    float core_y = 0.;
    float core_w = coreSize.width;
    float core_h = rect.size.height;
    UILabel *coreLabel = [[UILabel alloc] initWithFrame:CGRectMake(core_x, core_y, core_w, core_h)];
    coreLabel.text = coreName;
    coreLabel.font = font;
    coreLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:coreLabel];
    [coreLabel release];
    
    float core2_w = swidthWidth;
    float core2_h = 30;
    float core2_x = core_x + core_w;
    float core2_y = (rect.size.height - core2_h) / 2;
    CGRect core2Frame = CGRectMake(core2_x, core2_y, core2_w, core2_h);
    UISwitch *coreSwitch = [[UISwitch alloc] initWithFrame:core2Frame];
    [coreSwitch setOn:NO];
    [self addSubview:coreSwitch];
    self.coreSwitch = coreSwitch;
    [coreSwitch release];
    
    NSString *waitName = @"待议：";
    CGSize waitNameSize = [waitName sizeWithFont:font];
    float wait_x = CGRectGetMaxX(core2Frame) + margin;
    float wait_y = 0.;
    float wait_w = waitNameSize.width;
    float wait_h = rect.size.height;
    UILabel *waitLabel = [[UILabel alloc] initWithFrame:CGRectMake(wait_x, wait_y, wait_w, wait_h)];
    waitLabel.text = waitName;
    waitLabel.font = font;
    waitLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:waitLabel];
    [waitLabel release];
    
    float wait2_w = swidthWidth;
    float wait2_h = 30;
    float wait2_x = wait_x + wait_w;
    float wait2_y = (rect.size.height - wait2_h) / 2;
    UISwitch *waitSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(wait2_x, wait2_y, wait2_w, wait2_h)];
    [waitSwitch setOn:NO];
    [self addSubview:waitSwitch];
    self.waitSwitch = waitSwitch;
    [waitSwitch release];
    
    float search_w = 60;
    float search_h = 40;
    float search_x = rect.size.width - search_w - 10;
    float search_y = (rect.size.height - search_h) / 2;
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(search_x, search_y, search_w, search_h)];
    searchButton.backgroundColor = [UIColor whiteColor];
    [searchButton setTitle:@"查询" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"btn_img.png"] forState:UIControlStateNormal];
    [self addSubview:searchButton];
    [searchButton release];
}

- (void)dealloc
{
    self.nameField = nil;
    self.scoredSeg = nil;
    self.coreSwitch = nil;
    self.waitSwitch = nil;
    
    [super dealloc];
}

- (void)doSearch:(id)sender
{
    [_nameField resignFirstResponder];
    
    NSString *name = _nameField.text;
    if ([Common isEmptyString:name])
        name = @"";
    int scoredIndex = _scoredSeg.selectedSegmentIndex;
    BOOL isCore = _coreSwitch.isOn;
    BOOL isWait = _waitSwitch.isOn;
    
    NSDictionary *searchDic = [[[NSDictionary alloc] initWithObjectsAndKeys:
                              name, KEY_searchName,
                              [NSNumber numberWithInt:scoredIndex], KEY_searchScored,
                              [NSNumber numberWithBool:isCore], KEY_searchCore,
                              [NSNumber numberWithBool:isWait], KEY_searchWait,
                              nil] autorelease];
    
    [Common callDelegate:_delegate method:@selector(doSearch:) withObject:searchDic];
}

@end

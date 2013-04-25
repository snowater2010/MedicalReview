//
//  MR_PathNodeView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-25.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_PathNodeView.h"

@interface MR_PathNodeView()

@property(nonatomic, retain) NIDropDown *dropDown;

@end

@implementation MR_PathNodeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _nodeData = nil;
        _dropDown = nil;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //dropdown list
    CGRect btnSelectFrame = CGRectMake(10, 10, rect.size.width - 20, 40);
    UIButton *btnSelect = [[UIButton alloc] initWithFrame:btnSelectFrame];
    btnSelect.layer.borderWidth = 1;
    btnSelect.layer.borderColor = [[UIColor blackColor] CGColor];
    btnSelect.layer.cornerRadius = 5;
    
    [btnSelect addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnSelect.tag = 100;
    
    [btnSelect setTitle:@"Hello" forState:UIControlStateNormal];
    [btnSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self addSubview:btnSelect];
}

- (IBAction)selectClicked:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"Hello 0", @"Hello 1", @"Hello 2", @"Hello 3", @"Hello 4", @"Hello 5", @"Hello 6", @"Hello 7", @"Hello 8", @"Hello 9",nil];
    if(_dropDown == nil) {
        CGFloat f = 200;
        _dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        _dropDown.delegate = self;
    }
    else {
        [_dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
}

-(void)rel{
    self.dropDown = nil;
}

- (void)dealloc
{
    self.nodeData = nil;
    self.dropDown = nil;
    [super dealloc];
}

@end

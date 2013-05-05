//
//  MR_ScoreRadioView.m
//  MedicalReview
//
//  Created by lipeng11 on 13-4-30.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ScoreRadioView.h"

@implementation MR_ScoreRadioView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textSize = DEFAULT_TEXT_SIZE;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (!_choiceData || _choiceData.count <= 0) {
        return;
    }
    
    float choiceUnitWith = rect.size.width / _choiceData.count;
    
    float radio_h = RADIO_SIZE;
    float radio_y = (rect.size.height - radio_h) / 2;
    float radio_w = RADIO_SIZE;
    
    float name_y = 0.0f;
    float name_w = choiceUnitWith - RADIO_SIZE;
    float name_h = rect.size.height;
    
    float local_x = 0;
    int i = 0;
    for (NSDictionary *dic in _choiceData) {
        NSString *name = [dic objectForKey:@"name"];
        
        CGRect radioFrame = CGRectMake(local_x, radio_y, radio_w, radio_h);
        RadioButton *radioView = [[RadioButton alloc] init];
        [self registerInstance:radioView];
        radioView.frame = radioFrame;
        [self addSubview:radioView];
        [radioView release];
        
        float name_x = local_x + RADIO_SIZE;
        CGRect nameFrame = CGRectMake(name_x, name_y, name_w, name_h);
        UILabel *nameView = [[UILabel alloc] initWithFrame:nameFrame];
        nameView.text = name;
        nameView.font = [UIFont systemFontOfSize:_textSize];
        [self addSubview:nameView];
        [nameView release];
        
        local_x += RADIO_SIZE + name_w;
        i++;
    }
}

- (void)dealloc
{
    self.choiceData = nil;
    self.rb_instances = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark - Manage Instances

-(void)registerInstance:(RadioButton*)radioButton{
    if(!_rb_instances){
        _rb_instances = [[NSMutableArray alloc] init];
    }
    
    radioButton.delegate = self;
    
    [_rb_instances addObject:radioButton];
    // Make it weak reference
    [radioButton release];
}

#pragma mark - Class level handler

-(void)handleButtonTap:(id)sender{
    RadioButton *radioButton = (RadioButton *) sender;
    [self buttonSelected:radioButton];
}

-(void)buttonSelected:(RadioButton*)radioButton{
    // Unselect the other radio buttons
    if (_rb_instances) {
        int btIndex = 0;
        for (int i = 0; i < [_rb_instances count]; i++) {
            RadioButton *button = [_rb_instances objectAtIndex:i];
            if (![button isEqual:radioButton]) {
                [button otherButtonSelected:radioButton];
            }
            else {
                btIndex = i;
            }
        }
        NSString *key = [[_choiceData objectAtIndex:btIndex] objectForKey:@"key"];
        if ([_delegate respondsToSelector:@selector(radioButtonGroupTaped:)]) {
            [_delegate performSelector:@selector(radioButtonGroupTaped:) withObject:key];
        }
    }
}

@end

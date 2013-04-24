//
//  MR_LoginCtro.h
//  MedicalReview
//
//  Created by lipeng11 on 13-4-24.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_RootController.h"

@interface MR_LoginCtro : MR_RootController

@property(nonatomic, retain) IBOutlet UITextField   *ibName;
@property(nonatomic, retain) IBOutlet UITextField   *ibPassWord;
@property(nonatomic, retain) IBOutlet UIButton      *ibLoginBt;
@property(nonatomic, retain) IBOutlet UIControl     *ibRemember;

- (IBAction)clickRememberIv:(id)sender;
- (IBAction)doLogin:(id)sender;

@end

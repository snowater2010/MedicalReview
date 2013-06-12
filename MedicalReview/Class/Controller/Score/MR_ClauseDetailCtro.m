//
//  MR_ClauseDetail.m
//  MedicalReview
//
//  Created by lipeng11 on 13-6-11.
//  Copyright (c) 2013年 medical.review. All rights reserved.
//

#import "MR_ClauseDetailCtro.h"
#import "MR_ClauseLinkWebCtro.h"

@interface MR_ClauseDetailCtro ()

@end

@implementation MR_ClauseDetailCtro

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)reloadData
{
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.clauseData = nil;
    self.tableView = nil;
    [super dealloc];
}

#pragma mark-
#pragma tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CLAUSE_DETAIL_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect cellRect = CGRectMake(0, 0, tableView.frame.size.width, CLAUSE_DETAIL_CELL_HEIGHT);
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:cellRect] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *name = @"";
    NSString *content = @"";
    switch (indexPath.row) {
        case 0:
            name = @"资料查阅：";
            content = [_clauseData objectForKey:KEY_datainSpection];
            break;
        case 1:
            name = @"调查访谈：";
            content = [_clauseData objectForKey:KEY_surveyEnterview];
            break;
        case 2:
            name = @"实地访谈：";
            content = [_clauseData objectForKey:KEY_factView];
            break;
        case 3:
            name = @"个案追踪：";
            content = [_clauseData objectForKey:KEY_caseTrack];
            break;
        case 4:
            name = @"抽查考核：";
            content = [_clauseData objectForKey:KEY_checkAccess];
            break;
        case 5:
            name = @"依据连接：";
            content = [_clauseData objectForKey:KEY_proofLink];
            break;
        case 6:
            name = @"名词释义：";
            content = [_clauseData objectForKey:KEY_wordExplan];
            break;
        case 7:
            name = @"范本展示：";
            content = [_clauseData objectForKey:KEY_templateDisplay];
            break;
            break;
        default:
            break;
    }
    
    float name_x = 0;
    float name_y = 0;
    float name_w = cellRect.size.width * 0.25;
    float name_h = CLAUSE_DETAIL_CELL_HEIGHT;
    CGRect name_rect = CGRectMake(name_x, name_y, name_w, name_h);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:name_rect];
    nameLabel.backgroundColor = [Common colorWithR:254 withG:254 withB:222];
    nameLabel.text = name;
    nameLabel.textAlignment = _ALIGN_RIGHT;
    [cell.contentView addSubview:nameLabel];
    [nameLabel release];
    
    float content_x = CGRectGetMaxX(name_rect);
    float content_y = 0;
    float content_w = cellRect.size.width - name_w;
    float content_h = CLAUSE_DETAIL_CELL_HEIGHT;
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(content_x, content_y, content_w, content_h)];
    contentLabel.text = content;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = _ALIGN_LEFT;
    contentLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:contentLabel];
    [contentLabel release];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        MR_ClauseLinkWebCtro *linkCtro = [[MR_ClauseLinkWebCtro alloc] initWithNibName:@"MR_ClauseLinkWebCtro" bundle:nil];
        linkCtro.view.backgroundColor = [UIColor redColor];
        [self presentModalViewController:linkCtro animated:YES];
        [linkCtro release];
    }
}

@end

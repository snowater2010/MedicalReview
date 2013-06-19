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
        default:
            break;
    }
    
    UIFont *font = [UIFont systemFontOfSize:16];
    
    float name_x = 0;
    float name_y = 0;
    float name_w = cellRect.size.width * 0.2;
    float name_h = CLAUSE_DETAIL_CELL_HEIGHT;
    CGRect name_rect = CGRectMake(name_x, name_y, name_w, name_h);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:name_rect];
    nameLabel.backgroundColor = [Common colorWithR:254 withG:254 withB:222];
    nameLabel.text = name;
    nameLabel.textAlignment = _ALIGN_RIGHT;
    nameLabel.font = font;
    [cell.contentView addSubview:nameLabel];
    [nameLabel release];
    
    NSString *splitFlag = @"@:";
    if ([content isContainsString:splitFlag]) {
        NSArray *array = [content componentsSeparatedByString:splitFlag];
        float padding = 10;
        float loc_x = CGRectGetMaxX(name_rect);
        for (NSString *str in array) {
            CGSize size = [str sizeWithFont:font];
            CGRect rect = CGRectMake(loc_x, 0, size.width, CLAUSE_DETAIL_CELL_HEIGHT);
            UIButton *button = [[UIButton alloc] initWithFrame:rect];
            [button setTitle:str forState:UIControlStateNormal];
            [button setTitleColor:[UIColor flatDarkBlueColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor flatDarkBlackColor] forState:UIControlStateHighlighted];
            button.titleLabel.font = font;
            [button addTarget:self action:@selector(doLink:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            [button release];
            loc_x += size.width + padding;
        }
        
    }
    else {
        float content_x = CGRectGetMaxX(name_rect);
        float content_y = 0;
        float content_w = cellRect.size.width - name_w;
        float content_h = CLAUSE_DETAIL_CELL_HEIGHT;
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(content_x, content_y, content_w, content_h)];
        contentLabel.text = content;
        contentLabel.numberOfLines = 0;
        contentLabel.textAlignment = _ALIGN_LEFT;
        contentLabel.font = font;
        [cell.contentView addSubview:contentLabel];
        [contentLabel release];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        MR_ClauseLinkWebCtro *linkCtro = [[MR_ClauseLinkWebCtro alloc] initWithNibName:@"MR_ClauseLinkWebCtro" bundle:nil];
        [self presentModalViewController:linkCtro animated:YES];
        [linkCtro release];
    }
}

- (void)doLink:(id)sender
{
    _GET_APP_DELEGATE_(appDelegate);
    NSMutableString *serverUrl = [[NSMutableString alloc] initWithString:appDelegate.globalinfo.serverInfo.strWebServiceUrl];
    
//    @"http://222.173.30.135:8088/ylpj/ylgl/indexPointFile/名词解释/对口支援.htm"
    
    UIButton *button = (UIButton *)sender;
    NSString *title = button.titleLabel.text;
    
    [serverUrl appendFormat:@"/indexPointFile/%@.htm", title];
    
    MR_ClauseLinkWebCtro *linkCtro = [[MR_ClauseLinkWebCtro alloc] initWithNibName:@"MR_ClauseLinkWebCtro" bundle:nil];
    linkCtro.urlString = serverUrl;
    [self presentModalViewController:linkCtro animated:YES];
    [linkCtro release];
}

@end

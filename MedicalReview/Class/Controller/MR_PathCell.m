//
//  MR_PathCell.m
//  MedicalReview
//
//  Created by Rainbow on 4/27/13.
//  Copyright (c) 2013 medical.review. All rights reserved.
//

//*******************************************************************************
//这里CustomView类 也可以新建一个类 再引入头文件回来
//*******************************************************************************
@interface CustomView : UIView
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSDictionary *cellModel;
@property (nonatomic,assign) Boolean selected;
@end
@implementation CustomView
@synthesize model = _model,cellModel=_cellModel,selected=_selected;

- (id)initWithFrame:(CGRect)frame{
     self = [super initWithFrame:frame];
     if (self) {
          //*******************************************************************************
          //设置 背景透明或其他颜色，不然多次重绘时之前绘制的内容都还在，会叠加到一块儿
          //*******************************************************************************
          self.backgroundColor = [UIColor clearColor];
         }
     return self;
}

- (void)drawRect:(CGRect)rect{
     //*******************************************************************************
     //绘制Cell内容，NSString UIImage 等有drawInRect或者drawAtPoint 方法的都可以在这里绘制
     //*******************************************************************************
     [[UIColor redColor] set];
    
     NSString *imageName;
    
     if(!self.selected){
          if ([_cellModel objectForKey:@"totalCount"]==[_cellModel objectForKey:@"finishCount"]) {
               imageName = @"festival_cell_bg_3.9.png";
            
               //self.backgroundColor = [UIColor purpleColor];
              }else{
                   imageName = @"festival_cell_bg_1.9.png";
                
                   //self.backgroundColor = [UIColor grayColor];
                  }
         }else{
              imageName = @"festival_cell_bg_0.9.png";
              //self.backgroundColor = [UIColor grayColor];
             }
    
     UIImage *cellBgImage = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    
    // UIImage *cellBgImage = [UIImage imageNamed:@"bg_edit_text.9.png"];//bg_fresh_normal.9.png bg_edit_text.9.png festival_cell_bg_3.9.png
     //[cellBgImage stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
     [cellBgImage drawInRect:CGRectMake(0, 0, rect.size.width,rect.size.height )];
    
    
     //绘制一张图片
     //UIImage *image = [UIImage imageNamed:@"headImage.jpg"];
     //[image drawAtPoint:CGPointMake(5, 5)];
     //[image drawInRect:CGRectMake(5, 5, 50, 50)];
    
    
     //绘制一个字符串 drawInRect: 在某个区域内 withFont: 以什么字体
     //[_model drawInRect:CGRectMake(60, 5, 200, 30) withFont:[UIFont systemFontOfSize:18]];
     NSString *name = [NSString stringWithFormat:@"%@",[_cellModel objectForKey:@"nodeName"]];
     NSString *desc = [NSString stringWithFormat:@"(共%@款，已录入%@款)",[_cellModel objectForKey:@"totalCount"],[_cellModel objectForKey:@"finishCount"]];
    
     [name drawInRect:CGRectMake(10, 5, 200, 30) withFont:[UIFont systemFontOfSize:18]];
     [desc drawInRect:CGRectMake(10, 40, 200, 30) withFont:[UIFont systemFontOfSize:12]];
    
     /*
         [[UIColor greenColor] set];
         //绘制图形
         CGContextRef context = UIGraphicsGetCurrentContext();
         UIGraphicsPushContext(context);
         CGContextBeginPath(context);
         //
         //这之间的内容决定你画的是什么图形
         CGContextAddArc(context, 70, 40, 10, 0.0, 2*M_PI, NO);// (70, 40)为圆心 10 是半径
         //这之间的内容决定你画的是什么图形
         //
         CGContextFillPath(context);
         UIGraphicsPopContext();
         //
         //根据需要，你可以在这里绘制Cell内容来定制你的cell
         //那些不需要响应点击等事件的元素都可以绘制到CustomView上
         //需要响应点击事件等的UIView，如UIButton则需要addSubview到cell.contentView上
         //
         */
    
}

- (void)setModel:(NSString *)model{
     _model = model;
     //这里setNeedsDisplay 重绘自己
     [self setNeedsDisplay];
}

- (void)setCellModel:(NSDictionary *)model{
     _cellModel = model;
     //这里setNeedsDisplay 重绘自己
     [self setNeedsDisplay];
}
@end



#import "MR_PathCell.h"
@interface MR_PathCell() {
     CustomView *cView;
}
@end
@implementation MR_PathCell
@synthesize model = _model,cellModel = _cellModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
     if (self) {
          [cView removeFromSuperview];
          //*******************************************************************************
          //实例化 cView 并添加到 cell的contentView 上
          //那些不需要响应点击等事件的元素都可以绘制到CustomView上
          //需要响应点击事件等的UIView，如UIButton则需要addSubview到self.contentView上
          //*******************************************************************************
          cView = [[CustomView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [MR_PathCell cellHeight])];
          [self.contentView addSubview:cView];
         }
     return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
     [super setSelected:selected animated:animated];
     cView.selected = selected;
     [cView setNeedsDisplay];
    
     // Configure the view for the selected state
}

- (void)setModel:(NSString *)model{
     _model = model;
     //*******************************************************************************
     //设置cView 的model属性， 由于CustomView 实现了- (void)setModel:(NSString *)model; 同时也会调用这个方法
     //*******************************************************************************
     cView.model = _model;
}

- (void)setCellModel:(NSDictionary *)model{
     _cellModel = model;
     //*******************************************************************************
     //设置cView 的model属性， 由于CustomView 实现了- (void)setModel:(NSString *)model; 同时也会调用这个方法
     //*******************************************************************************
     cView.cellModel = _cellModel;
}

+ (float)cellHeight{
     return 60;//如果你需要高度随内容变化的cell，在这里返回高度计算结果
}


@end

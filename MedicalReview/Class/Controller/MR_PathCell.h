#import <UIKit/UIKit.h>

@interface MR_PathCell : UITableViewCell
@property (nonatomic, strong) NSString *model;//这里为了简洁就不引入Model新类，用String先代替
@property(nonatomic, strong) NSDictionary *cellModel;
+ (float)cellHeight;
@end
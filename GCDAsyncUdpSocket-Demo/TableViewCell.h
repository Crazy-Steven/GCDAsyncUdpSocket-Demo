//
//  TableViewCell.h
//  itheima-QQ聊天
//
//  Created by 郭艾超 on 15/2/1.
//  Copyright © 2015年 郭艾超. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FrameModel;
@interface TableViewCell : UITableViewCell
@property (strong, nonatomic)FrameModel * Fmodel;
+ (instancetype)cellWithTableView:(UITableView *)tableview;
@end

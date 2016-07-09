//
//  FrameModel.m
//  itheima-QQ聊天
//
//  Created by 郭艾超 on 15/2/1.
//  Copyright © 2015年 郭艾超. All rights reserved.
//

#import "FrameModel.h"
#import "DataModel.h"
@implementation FrameModel
- (void)setDatamodel:(DataModel *)datamodel
{
    _datamodel = datamodel;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    if (!datamodel.isTimeHidden) {
        _timeF = CGRectMake(0, 0, width, 40);
    }
    
    CGFloat padding = 10;
    CGFloat headW = 40;
    CGFloat headH = 40;
    CGFloat headX = padding;
    CGFloat headY = CGRectGetMaxY(_timeF) + padding;
    
    CGFloat textY = headY - padding * 0.5;
    CGFloat textX = headX + headW + padding;
    CGSize textMax = CGSizeMake((width - headW - 6 * padding), MAXFLOAT);
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGSize textSize = [datamodel.text boundingRectWithSize:textMax options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    if (datamodel.type == QQModelTypeMe) {
        headX = width - headW - 2 * padding ;
        textX = width - headW - 6 * padding - textSize.width;
    }
    _headF = CGRectMake(headX, headY, headW, headH);
    _textF = CGRectMake(textX , textY , textSize.width + 30, textSize.height + 30);
    
    CGFloat textMaxY = CGRectGetMaxY(_textF);
    CGFloat headMaxY = CGRectGetMaxY(_headF);
    (textMaxY > headMaxY) ? (_cellHeight = textMaxY) : (_cellHeight = headMaxY);
    
    
}
@end

//
//  TableViewCell.m
//  itheima-QQ聊天
//
//  Created by 郭艾超 on 15/2/1.
//  Copyright © 2015年 郭艾超. All rights reserved.
//

#import "TableViewCell.h"
#import "FrameModel.h"
#import "DataModel.h"
@interface TableViewCell()
@property (weak, nonatomic)UILabel * timeLabel;
@property (weak, nonatomic)UIImageView * headImg;
@property (weak, nonatomic)UIButton * textBtn;
@end
@implementation TableViewCell

- (void)awakeFromNib {
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString * ID = @"QQCell";
    TableViewCell * cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setFmodel:(FrameModel *)Fmodel
{
    _Fmodel = Fmodel;
    
    _timeLabel.frame = Fmodel.timeF;
    _timeLabel.text = Fmodel.datamodel.time;
    
    _headImg.frame = Fmodel.headF;
    _textBtn.frame = Fmodel.textF;
    [_textBtn setTitle:Fmodel.datamodel.text forState:UIControlStateNormal];
    UIImage * sendImgNor = [self resizableWithName:@"chat_send_nor"] ;
    UIImage * sendImgPress = [self resizableWithName:@"chat_send_press_pic"] ;
    UIImage * recieveImgNor = [self resizableWithName:@"chat_recive_nor"] ;
    UIImage * recieveImgPress = [self resizableWithName:@"chat_recive_press_pic"] ;
    _headImg.image = [UIImage imageNamed:@"other"];
    [_textBtn setBackgroundImage:recieveImgNor forState:UIControlStateNormal];
    [_textBtn setBackgroundImage:recieveImgPress forState:UIControlStateHighlighted];
    if (Fmodel.datamodel.type == QQModelTypeMe) {
        _headImg.image = [UIImage imageNamed:@"me"];
        
        [_textBtn setBackgroundImage:sendImgNor forState:UIControlStateNormal];
        [_textBtn setBackgroundImage:sendImgPress forState:UIControlStateHighlighted];
    }
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel * timeLabel = [[UILabel alloc]init];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:timeLabel];
        _timeLabel = timeLabel;
        
        UIImageView * headImg = [[UIImageView alloc]init];
        [self.contentView addSubview:headImg];
        _headImg = headImg;
        
        UIButton * textBtn = [[UIButton alloc]init];
        [textBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        textBtn.titleLabel.numberOfLines = 0;
        textBtn.contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        textBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:textBtn];
        _textBtn = textBtn;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImage *)resizableWithName:(NSString *)img
{
    UIImage * oldimg = [UIImage imageNamed:img];
    
    CGFloat w = oldimg.size.width * 0.5;
    CGFloat h = oldimg.size.height * 0.5;
    
    return [oldimg resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
}
@end

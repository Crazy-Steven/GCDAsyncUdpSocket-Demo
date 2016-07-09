//
//  FrameModel.h
//  itheima-QQ聊天
//
//  Created by 郭艾超 on 15/2/1.
//  Copyright © 2015年 郭艾超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DataModel;
@interface FrameModel : NSObject
@property (strong, nonatomic)DataModel * datamodel;

@property (assign, nonatomic, readonly)CGRect timeF;
@property (assign, nonatomic, readonly)CGRect headF;
@property (assign, nonatomic, readonly)CGRect textF;
@property (assign, nonatomic, readonly)CGFloat cellHeight;
@end

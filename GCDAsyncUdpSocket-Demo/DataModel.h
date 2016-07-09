//
//  DataModel.h
//  itheima-QQ聊天
//
//  Created by 郭艾超 on 15/2/1.
//  Copyright © 2015年 郭艾超. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    QQModelTypeMe,
    QQModelTypeOther
}type;
@interface DataModel : NSObject

@property (copy, nonatomic)NSString * text;
@property (copy, nonatomic)NSString * time;
@property (assign, nonatomic)type type;
@property (assign, nonatomic,getter = isTimeHidden)BOOL timeHidden;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end

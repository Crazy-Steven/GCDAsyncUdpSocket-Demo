//
//  ViewController.m
//  itheima-QQ聊天
//
//  Created by 郭艾超 on 15/2/1.
//  Copyright © 2015年 郭艾超. All rights reserved.
//

#import "ViewController.h"
#import "FrameModel.h"
#import "DataModel.h"
#import "TableViewCell.h"
#import "GCDAsyncUdpSocket.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,GCDAsyncUdpSocketDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic)NSMutableArray * dataArr;
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (strong, nonatomic)GCDAsyncUdpSocket * udpSocket;
@end

#define udpPort 2345
@implementation ViewController
- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        
        _dataArr = [NSMutableArray array];
        
        NSArray * tempArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"messages.plist" ofType:nil ]];
        
        for (NSDictionary * dict in tempArr) {
            
            DataModel * Dmodel = [DataModel modelWithDict:dict];
            FrameModel * Fmodel = [[FrameModel alloc]init];
            
            FrameModel * oldFmodel = [_dataArr lastObject];
            
            if ([oldFmodel.datamodel.time isEqualToString:Dmodel.time]) {
                Dmodel.timeHidden = YES;
            }
            Fmodel.datamodel = Dmodel;
            [_dataArr addObject:Fmodel];
        }
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:_dataArr.count - 1 inSection:0];
        [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.myTableView.allowsSelection = NO;
    
    self.myTableView.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    
    UIView * none = [[UIView alloc]initWithFrame:(CGRect){0,0,10,0}];
    self.myTextField.leftView = none;
    self.myTextField.leftViewMode = UITextFieldViewModeAlways;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError * error = nil;
    [_udpSocket bindToPort:udpPort error:&error];
    if (error) {
        NSLog(@"error:%@",error);
    }else {
        [_udpSocket beginReceiving:&error];
    }
    
}

#pragma mark - Action
- (void)sendMessage:(NSString *)message andType:(NSNumber *)type{
    
    NSDate * now = [NSDate date];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    
    formatter.dateFormat = @"HH:mm";
    
    NSDictionary * dict = @{@"time":[formatter stringFromDate:now],
                            @"text":message,
                            @"type":type};
    FrameModel * fModel = [[FrameModel alloc]init];
    DataModel * dModel = [DataModel modelWithDict:dict];
    
    FrameModel * timeModel1 = [_dataArr lastObject];
    DataModel * timeModel2 = timeModel1.datamodel;
    
    if ([dict[@"time"] isEqualToString:timeModel2.time]) {
        dModel.timeHidden = YES;
    }
    fModel.datamodel = dModel;
    
    [_dataArr addObject:fModel];
    [self.myTableView reloadData];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:_dataArr.count - 1 inSection:0];
    [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)viewChanged:(NSNotification *)userInfo
{
    NSDictionary * dict = userInfo.userInfo;
    
    CGRect keyboardF = [dict[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGFloat ty = keyboardF.origin.y-[UIScreen mainScreen].bounds.size.height;
    NSTimeInterval time = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:time animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}

#pragma mark - tableview datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell * cell = [TableViewCell cellWithTableView:tableView];
    FrameModel * Fmodel = self.dataArr[indexPath.row];
    cell.Fmodel = Fmodel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FrameModel * fmodel = self.dataArr[indexPath.row];
    
    return fmodel.cellHeight;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessage:textField.text andType:@0];
    
    NSString * ipAddress = [self deviceIPAdress];
    
    NSData * sendData = [textField.text dataUsingEncoding:NSUTF8StringEncoding];
    
    [_udpSocket sendData:sendData toHost:ipAddress port:udpPort withTimeout:-1 tag:0];
    
    textField.text = nil;
    
    return YES;
}

#pragma mark - GCDAsyncUdpSocket delegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"发送信息成功");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"发送信息失败");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    
    NSLog(@"接收到%@的消息",address);
    NSString * sendMessage = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    [self sendMessage:sendMessage andType:@1];
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"udpSocket关闭");
}
@end

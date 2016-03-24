//
//  ViewController.m
//  QQText
//
//  Created by y on 16/3/17.
//  Copyright © 2016年 y. All rights reserved.
//

#import "ViewController.h"
#import "QQText.h"

@interface ViewController ()<UITextViewDelegate>
@property (nonatomic, strong) QQText *qqtext;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // 数据-JSON格式
  NSArray *dataArray = @[
                         @{@"type":@(TEXT),@"content":@"江南皮革厂倒闭了,黄鹤老板跑路不是人"},
                         @{@"type":@(IMAGE),@"content":@"logo",@"size":@{@"width":@(25),@"height":@(25)}},
                         @{@"type":@(URL),@"content":@"一行白鹭",@"link":@"http://baidu.com"},
                         @{@"type":@(TEXT),@"content":@"\nI only love"}
                         ];
  // 初始化
  self.qqtext = [[QQText alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height) dataArray:dataArray];
  [self.view addSubview:self.qqtext];
  self.qqtext.delegate = self;
  
}

#pragma textview - delegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0) {
  NSLog(@"%@",URL);
  return false;
}



@end

//
//  QQText.m
//  QQText
//
//  Created by y on 16/3/24.
//  Copyright © 2016年 y. All rights reserved.
//

#import "QQText.h"
@interface QQText()
@property (nonatomic,strong) NSArray *data;
@end
@implementation QQText

- (instancetype) initWithFrame:(CGRect)frame dataArray:(NSArray *)data {
  if (self = [self init]) {
    self.frame = frame;
    self.editable = false;
    self.data = data;
  }
  return self;
}

// 填充数据
- (void)setData:(NSArray *)data {
  if (_data == nil) {
    _data = data;
    // 难点 1.计算高度 . 2.添加图片，.获取位置 . 3.识别超链接可以点击 . 4.图片点击放大
    // 难点 2.解析html, 缓存
    // SDImageCache 下载完成回调
    // 加链接
    NSMutableAttributedString *attrstring = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    for(NSDictionary *dic in data) {
      if ([dic[@"type"]  isEqual: @(TEXT)]) {
        NSLog(@"文字");
        NSAttributedString *content = [[NSAttributedString alloc] initWithString:dic[@"content"]];
        [attrstring appendAttributedString:content];
      } else if ([dic[@"type"] isEqual:@(IMAGE)]) {
        NSString *url = dic[@"content"];
        if ([url containsString:@"http"]) {
          NSLog(@"网络图片");
        } else {
          NSLog(@"本地图片");
          NSTextAttachment * pic = [[NSTextAttachment alloc]init];
          pic.image = [UIImage imageNamed:dic[@"content"]];
          if (dic[@"size"] != nil) {
            CGSize size = CGSizeMake(0, 0);
            NSNumber *width = dic[@"size"][@"width"];
            size.width = width.floatValue;
            NSNumber *height = dic[@"size"][@"height"];
            size.height = height.floatValue;
            NSLog(@"%f %f",size.width,size.height);
            pic.bounds = CGRectMake(0, 0, size.width,size.height);
          }
          
          NSAttributedString *imgAttributed = [NSAttributedString attributedStringWithAttachment:pic];
          [attrstring appendAttributedString:imgAttributed];

        }
      }
    }
    self.attributedText = attrstring;
//    插入链接
//    [attrstring addAttribute:NSLinkAttributeName
//                       value:@"http://www.baidu.com"
//                       range:[s1 rangeOfString:s1]];
//    
//    // 插入图片
//    NSLog(@"len:%lu",(unsigned long)attrstring.length);
//    [attrstring insertAttributedString:imgAttributed atIndex:3];
//    NSLog(@"len:%lu",(unsigned long)attrstring.length);
//    //[attrstring replaceCharactersInRange:NSMakeRange(3, 1) withString:@"2333"];
//    self.qqtext.attributedText = attrstring;
//    NSLog(@"len:%lu",(unsigned long)self.qqtext.attributedText.length);
    //  dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //    [NSThread sleepForTimeInterval:1.0f];
    //    //回到主线程
    //
    //    dispatch_sync(dispatch_get_main_queue(), ^{//其实这个也是在子线程中执行的，只是把它放到了主线程的队列中
    //
    //      NSTextAttachment * pic = [[NSTextAttachment alloc]init];
    //      pic.image = [UIImage imageNamed:@"logo"];
    //      pic.bounds = CGRectMake(0, 0, 50, 50);
    //      NSAttributedString *imgAttributed = [NSAttributedString attributedStringWithAttachment:pic];
    //      [attrstring insertAttributedString:imgAttributed atIndex:3];
    //      self.yytext.attributedText = attrstring;
    //
    //    });
    //
    //  });

  }
}
@end

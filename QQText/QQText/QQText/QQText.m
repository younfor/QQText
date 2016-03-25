//
//  QQText.m
//  QQText
//
//  Created by y on 16/3/24.
//  Copyright © 2016年 y. All rights reserved.
//

#import "QQText.h"
#import "UIImageView+WebCache.h"
#import "QQAttachText.h"

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
        QQAttachText * pic = [[QQAttachText alloc]init];
        pic.url = url;
        pic.image = [[UIImage alloc] init];
        CGSize size = CGSizeMake(25, 25);
        if (dic[@"size"] != nil) {
          
          NSNumber *width = dic[@"size"][@"width"];
          size.width = width.floatValue;
          NSNumber *height = dic[@"size"][@"height"];
          size.height = height.floatValue;
          NSLog(@"%f %f",size.width,size.height);
        }
        pic.bounds = CGRectMake(0, 0, size.width,size.height);
        
        NSAttributedString *imgAttributed = [NSAttributedString attributedStringWithAttachment:pic];
        [attrstring appendAttributedString:imgAttributed];
        
      } else if ([dic[@"type"] isEqual:@(URL)]) {
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:dic[@"content"]];
        [attrstring appendAttributedString:content];
        [attrstring addAttribute:NSLinkAttributeName
                               value:dic[@"link"]
                               range:[[attrstring string] rangeOfString:dic[@"content"]]];
      }
    }
    self.attributedText = attrstring;

  }
}
- (void)setAttributedText:(NSAttributedString *)attributedText
{
  [super setAttributedText:attributedText];
  for (UIView* subView in self.subviews) {
    if ([subView isKindOfClass:[UIImageView class]]) {
      [subView removeFromSuperview];
    }
  }
  [self.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(QQAttachText* value, NSRange range, BOOL * _Nonnull stop) {
    if (value && [value isKindOfClass:[QQAttachText class]]) {
      NSLog(@"有图片");
      NSString *url = value.url;
      self.selectedRange = range;
      NSLog(@"%f,%f",value.bounds.size.width,value.bounds.size.height);
      CGRect rect = [self firstRectForRange:self.selectedTextRange];
      self.selectedRange = NSMakeRange(0, 0);
      UIImageView* imageView = [[UIImageView alloc] init];
      [self addSubview:imageView];
      imageView.frame = rect;
      if ([url containsString:@"http"]) {
        NSLog(@"网络图片%@",url);
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
      } else {
        NSLog(@"本地图片");
        imageView.image = [UIImage imageNamed:url];
      }
    }
  }];
  
}
@end

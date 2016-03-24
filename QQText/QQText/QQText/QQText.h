//
//  QQText.h
//  QQText
//
//  Created by y on 16/3/24.
//  Copyright © 2016年 y. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger){
  TEXT,IMAGE,URL
}TYPE;
@interface QQText : UITextView
// 构造函数
- (instancetype) initWithFrame:(CGRect)frame dataArray:(NSArray *)data;
@end

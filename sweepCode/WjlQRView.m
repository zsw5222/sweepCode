//
//  WjlQRView.m
//  
//
//  Created by mac on 15/12/3.
//  Copyright © 2015年 jinbi. All rights reserved.
//

#import "WjlQRView.h"

@implementation WjlQRView


- (void)setClearRect:(CGRect)clearRect{
    _clearRect = clearRect;
 
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];//背景黑色
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, _clearRect);//清除rect范围的内容
}
@end

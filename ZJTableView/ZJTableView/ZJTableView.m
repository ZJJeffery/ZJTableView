//
//  ZJTableView.m
//  panCheck
//
//  Created by Jiajun Zheng on 15/10/14.
//  Copyright © 2015年 zjProject. All rights reserved.
//

#import "ZJTableView.h"

@implementation ZJTableView
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    self.hitCell = [super hitTest:point withEvent:event];
    return self.hitCell;
}
@end

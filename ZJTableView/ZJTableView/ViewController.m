//
//  ViewController.m
//  ZJTableView
//
//  Created by Jiajun Zheng on 15/10/14.
//  Copyright © 2015年 zjProject. All rights reserved.
//

#import "ViewController.h"
#import "ZJTableView.h"
#import "ZJTableViewCell.h"
@interface ViewController ()
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) ZJTableView *tableView;
@property (nonatomic, strong) ZJTableViewCell *cellRed;
@property (nonatomic, strong) ZJTableViewCell *cellBlue;
@property (nonatomic, assign) CGFloat beganY;
@property (nonatomic, strong) UILabel *labelRed;
@property (nonatomic, strong) UILabel *labelBlue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    [self.tableView addGestureRecognizer:self.pan];
    
    [self.pan addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.tableView addSubview:self.cellRed];
    [self.tableView addSubview:self.cellBlue];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSInteger new = [change[@"new"] integerValue];
    if (new == UIGestureRecognizerStateFailed) {
        if ([self.tableView.hitCell isKindOfClass:[ZJTableViewCell class]]) {
            self.tableView.hitCell.label.text = @"点击";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tableView.hitCell.label.text = @"停止";
            });
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pan:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.beganY = self.tableView.bounds.origin.y;
        self.labelRed.text = @"滚动";
        self.labelBlue.text = @"滚动";
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat y = [pan translationInView:self.tableView].y;
        CGFloat realY = sqrt(y) * sqrt(y / 10);
        if (y < 0) {
            realY = y;
        }
        CGRect bounds = CGRectMake(0, self.beganY - realY, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
        self.tableView.bounds = bounds;
    }else if (pan.state == UIGestureRecognizerStateEnded){
        self.labelRed.text = @"停止";
        self.labelBlue.text = @"停止";
        if (self.tableView.bounds.origin.y != 0) {
            [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations:^{
                self.tableView.bounds = CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
            } completion:nil];
        }
    }
}
#pragma mark 懒加载
-(UIPanGestureRecognizer *)pan
{
    if (_pan == nil) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    }
    return _pan;
}
-(ZJTableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[ZJTableView alloc] initWithFrame:self.view.bounds];
    }
    return _tableView;
}
-(UIView *)cellRed
{
    if (_cellRed == nil) {
        _cellRed = [[ZJTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        _cellRed.backgroundColor = [UIColor redColor];
        [_cellRed addSubview:self.labelRed];
        _cellRed.label = self.labelRed;
        self.labelRed.center = CGPointMake(_cellRed.bounds.size.width * 0.5, _cellRed.bounds.size.height * 0.5);
    }
    return _cellRed;
}
-(UILabel *)labelRed
{
    if (_labelRed == nil) {
        _labelRed = [[UILabel alloc] init];
        _labelRed.text = @"停止";
        [_labelRed sizeToFit];
        _labelRed.textColor = [UIColor blackColor];
    }
    return _labelRed;
}
-(UILabel *)labelBlue
{
    if (_labelBlue == nil) {
        _labelBlue = [[UILabel alloc] init];
        _labelBlue.text = @"停止";
        [_labelBlue sizeToFit];
        _labelBlue.textColor = [UIColor blackColor];
    }
    return _labelBlue;
}
-(UIView *)cellBlue
{
    if (_cellBlue == nil) {
        _cellBlue = [[ZJTableViewCell alloc] initWithFrame:CGRectZero];
        _cellBlue.frame = CGRectMake(0, 300, self.view.frame.size.width, 300);
        _cellBlue.backgroundColor = [UIColor blueColor];
        [_cellBlue addSubview:self.labelBlue];
        _cellBlue.label = self.labelBlue;
        self.labelBlue.center = CGPointMake(_cellRed.bounds.size.width * 0.5, _cellRed.bounds.size.height * 0.5);
    }
    return _cellBlue;
}
@end


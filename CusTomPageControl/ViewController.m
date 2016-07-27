//
//  ViewController.m
//  qq粘性动画
//
//  Created by 王志盼 on 16/2/17.
//  Copyright © 2016年 王志盼. All rights reserved.
//

#import "ViewController.h"
#import "OCPageControlView.h"

#define count 4

@interface ViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) OCPageControlView *page;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 30)];
    textLabel.text = @"带有粘性动画的pageControl";
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:20];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textLabel];
    
    // Do any additional setup after loading the view, typically from a nib.
    UIScrollView * s = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    s.pagingEnabled = YES;
    s.delegate = self;
    [self.view addSubview:s];
    [self.view sendSubviewToBack:s];
    
    s.contentSize = CGSizeMake(self.view.frame.size.width * count, self.view.frame.size.height - 64);
    
    for (int i = 0; i < count; i++) {
        UILabel * l = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, self.view.frame.size.height)];
        l.textAlignment = NSTextAlignmentCenter;
        l.text = [NSString stringWithFormat:@"%d",i];
        [s addSubview:l];
        l.textColor = [UIColor blackColor];
    }
    
    OCPageControlView * page = [[OCPageControlView alloc]initWithFrame:CGRectMake(40, 100, self.view.frame.size.width, 0)andPageCount:count];
    page.center = CGPointMake(self.view.frame.size.width/2, 350);
    page.backgroundColor =[UIColor yellowColor];
    [self.view addSubview:page];
    self.page = page;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.page getX:scrollView.contentOffset.x];
    for (int i = 0 ; i  < count; i++) {
        if (scrollView.contentOffset.x == self.view.frame.size.width * i) {
            [self.page finsh];
        }
    }
}




@end

//
//  OCPageControlView.h
//  qq粘性动画
//
//  Created by 刘伟强 on 16/7/26.
//  Copyright © 2016年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCPageControlView : UIView

@property (strong, nonatomic) UIColor  *pageControlSelectColor;
@property (strong, nonatomic) UIColor  *pageControlNormalColor;

- (instancetype)initWithFrame:(CGRect)frame andPageCount:(NSInteger)count;

-(void)getX:(CGFloat )x;
-(void)finsh;
@end

//
//  OCPageControlView.m
//  qq粘性动画
//
//  Created by 刘伟强 on 16/7/26.
//  Copyright © 2016年 王志盼. All rights reserved.
//

#import "OCPageControlView.h"


#define  SFactor 25

@interface OCPageControlView ()

@property(nonatomic,strong)UIView * smallCircleView;
@property (strong, nonatomic) UIView  *selectCircle;

@property (nonatomic, assign) CGFloat smallCircleR;
@property (nonatomic, weak) CAShapeLayer *shapeLayer;

@end

@implementation OCPageControlView

- (instancetype)initWithFrame:(CGRect)frame andPageCount:(NSInteger)count
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.pageControlNormalColor = [UIColor colorWithWhite:0.816 alpha:1.000];
        self.pageControlSelectColor = [UIColor redColor];
        
        for (int i = 0; i < count; i++) {
            UIView * v = [[UIView alloc]initWithFrame:CGRectMake(-3 + 15 * i, 0, 6, 6)];
            v.layer.cornerRadius = 3;
            v.backgroundColor = self.pageControlNormalColor;
            [self addSubview:v];
            if (i == count-1) {
                self.frame = CGRectMake(frame.origin.x, frame.origin.y, v.frame.origin.x + v.frame.size.width, 6);
            }
        }
        self.selectCircle = [[UIView alloc] initWithFrame:CGRectMake(-3, 0, 6, 6)];
        self.selectCircle.backgroundColor = self.pageControlSelectColor;
        self.selectCircle.layer.cornerRadius = 3;
        [self addSubview:self.selectCircle];
        
        self.smallCircleView = [[UIView alloc] initWithFrame:CGRectMake(-3, 0, 6, 6)];
        self.smallCircleView.backgroundColor = self.pageControlSelectColor;
        self.smallCircleView.layer.cornerRadius = self.selectCircle.frame.size.height/2;
  
        [self addSubview:self.smallCircleView];
        
        self.smallCircleR = self.selectCircle.frame.size.height/2;
        
    }
    return self;
}

- (CAShapeLayer *)shapeLayer
{
    if (_shapeLayer == nil) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        if (self.selectCircle.center.x != self.smallCircleView.center.x) {
            shapeLayer.path = [self pathWithBigCircleView:self.selectCircle smallCircleView:self.smallCircleView].CGPath;
        }
        shapeLayer.fillColor = self.pageControlSelectColor.CGColor;
        [self.layer addSublayer:shapeLayer];
        _shapeLayer = shapeLayer;
    }
    return _shapeLayer;
}


- (void)getX:(CGFloat )x
{
    if (x == 0) {
        return;
    }
    
    CGPoint center = self.smallCircleView.center;
    center.x = x/SFactor * 375/[UIScreen mainScreen].bounds.size.width;
    self.selectCircle.center = center;
    CGFloat distance = [self distanceWithPointA:self.smallCircleView.center pointB:self.selectCircle.center];
    CGFloat newR = self.smallCircleR - distance / 20;
    self.smallCircleView.bounds = CGRectMake(0, 0, newR * 2, newR * 2);
    self.smallCircleView.layer.cornerRadius = newR;

    self.shapeLayer.path = [self pathWithBigCircleView:self.selectCircle smallCircleView:self.smallCircleView].CGPath;
}


-(void)finsh{
    CGPathRef path1 = [self pathWithBigCircleView:self.smallCircleView smallCircleView:self.selectCircle].CGPath;
    self.smallCircleView.center = CGPointMake(self.selectCircle.center.x + 0.1, self.selectCircle.center.y ) ;
    CGPathRef path2 = [self pathWithBigCircleView:self.smallCircleView smallCircleView:self.selectCircle].CGPath;
    CAKeyframeAnimation * ovalPathAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    ovalPathAnim.values                = @[(__bridge id)path1,(__bridge id)path2];
    ovalPathAnim.keyTimes              = @[@0, @1];
    ovalPathAnim.duration              = 0.11;
    ovalPathAnim.fillMode=kCAFillModeForwards;
    ovalPathAnim.removedOnCompletion = YES;
    [self.shapeLayer addAnimation:ovalPathAnim forKey:@"ovalUntitled1Anim"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.shapeLayer.path = [self pathWithBigCircleView:self.smallCircleView smallCircleView:self.selectCircle].CGPath;
    });
    double count = 4;
    
    [UIView animateKeyframesWithDuration:0.1 delay:0.07 options:UIViewKeyframeAnimationOptionCalculationModeDiscrete animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/count animations:^{
            self.selectCircle.center = CGPointMake(self.selectCircle.center.x - 1, self.selectCircle.center.y);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/count  relativeDuration:1/count animations:^{
            self.selectCircle.center = CGPointMake(self.selectCircle.center.x + 1, self.selectCircle.center.y);
        }];
        [UIView addKeyframeWithRelativeStartTime:2/count  relativeDuration:1/count animations:^{
            self.selectCircle.center = CGPointMake(self.selectCircle.center.x - 1, self.selectCircle.center.y);
        }];
        [UIView addKeyframeWithRelativeStartTime:3/count  relativeDuration:1/count animations:^{
            self.selectCircle.center = CGPointMake(self.selectCircle.center.x + 1, self.selectCircle.center.y);
        }];
    } completion:^(BOOL finished) {
        
    }];
}

- (CGFloat)distanceWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB
{
    CGFloat dx = pointB.x - pointA.x;
    CGFloat dy = pointB.y - pointA.y;
    
    return sqrt(dx * dx + dy * dy);
}

- (UIBezierPath *)pathWithBigCircleView:(UIView *)bigCircleView smallCircleView:(UIView *)smallCircleView
{
    CGPoint smallCircleCenter = smallCircleView.center;
    CGFloat x1 = smallCircleCenter.x ;
    CGFloat y1 = smallCircleCenter.y;
    CGFloat r1 = smallCircleView.bounds.size.height / 2;
    
    CGPoint BigCircleViewCenter = bigCircleView.center;
    CGFloat x2 = BigCircleViewCenter.x;
    CGFloat y2 = BigCircleViewCenter.y;
    CGFloat r2 = bigCircleView.bounds.size.height / 2;
    
    CGFloat d = [self distanceWithPointA:BigCircleViewCenter pointB:smallCircleCenter];
    
    //Θ:(xita)
    CGFloat sinθ = (x2 - x1) / d;
    CGFloat cosθ = (y2 - y1) / d;
    
    if (isnan(sinθ) ) {
        sinθ = 0;
    }
    if (isnan(cosθ)) {
        cosθ = 0;
    }
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ , y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ , y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2+ r2 * cosθ , y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ ,y2 + r2 * sinθ);
    CGPoint pointO = CGPointZero;
    CGPoint pointP = CGPointZero;
    if ((pointA.y + d / 2 * cosθ) > 5 ) {
        pointO  = CGPointMake(pointA.x + d / 2 * sinθ , pointA.y + d / 2 * cosθ - 1);
        pointP  =  CGPointMake(pointB.x + d / 2 * sinθ , pointB.y + d / 2 * cosθ + 1);
    }else{
        pointO = CGPointMake(pointA.x + d / 2 * sinθ , pointA.y + d / 2 * cosθ + 1);
        pointP =  CGPointMake(pointB.x + d / 2 * sinθ , pointB.y + d / 2 * cosθ - 1);
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // D
    [path moveToPoint:pointD];
    // DA
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    // AB
    [path addLineToPoint:pointB];
    // BC
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    // CD
    [path addLineToPoint:pointD];
    return path;
}

@end

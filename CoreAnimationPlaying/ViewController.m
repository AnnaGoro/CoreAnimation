//
//  ViewController.m
//  CoreAnimationPlaying
//
//  Created by AnnGorobchenko on 11/21/17.
//  Copyright © 2017 com.ann. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *box;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CALayer *layer = self.box.layer;
    layer.cornerRadius = 15.0f;
    layer.masksToBounds = NO;
    
    layer.shadowOffset = CGSizeMake(6, 6);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 7.0f;
    layer.shadowOpacity = 0.9f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:layer.bounds cornerRadius:layer.cornerRadius] CGPath];
    
    self.box.backgroundColor = nil;
    
    CAGradientLayer *viewLayer = [CAGradientLayer layer];
    viewLayer.masksToBounds = YES;
    viewLayer.cornerRadius = self.box.layer.cornerRadius;
    
    UIImage *image = [UIImage imageNamed:@"tree.jpg"];
        viewLayer.contents = (__bridge id _Nullable)(image.CGImage);
        viewLayer.contentsGravity = kCAGravityResizeAspectFill;
    
    [viewLayer setFrame: self.box.bounds];
    [self.box.layer insertSublayer:viewLayer atIndex:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(applyGroupAnimation)];
    
     [self.box addGestureRecognizer:tap];
    
    // [self applyPositionAnimationToLayer: self.box.layer];
    
    // [self applyKeyFrameAnimationToLayer:self.box.layer];
    
    // [self applyGroupAnimationToLayer:self.box.layer];
    
}

- (void)applyPositionAnimationToLayer:(CALayer*)layer{
    
    CABasicAnimation *theAnimation;
    
    theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    theAnimation.duration = 3.0;
    theAnimation.repeatCount = 5;
    theAnimation.autoreverses = //NO;
                                 YES;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    theAnimation.fromValue= [NSValue valueWithCGPoint:CGPointMake(width/2, layer.frame.origin.y)];
    theAnimation.toValue= [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    [layer addAnimation:theAnimation forKey:@"animatePosition"];
    
}

- (void)applyKeyFrameAnimationToLayer: (CALayer *)layer {
    NSArray * pathArray = @[ [NSValue valueWithCGPoint:CGPointMake(10., 10.)],
                             [NSValue valueWithCGPoint:CGPointMake(100., 10.)],
                             [NSValue valueWithCGPoint:CGPointMake(10., 100.)], 
                             [NSValue valueWithCGPoint:CGPointMake(10., 10.)], ];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.values = pathArray;
    pathAnimation.duration = 15.0;
    [layer addAnimation:pathAnimation forKey:@"position"];
    
}


- (void) applyTransitionAnimation{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 2.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    UIViewController * vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    [[self navigationController] pushViewController: vc animated:NO];
}

- (void) applyGroupAnimation {
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    [positionAnimation setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.box.layer.frame.origin.x + self.box.layer.frame.size.width/2, self.box.layer.frame.origin.y + self.box.layer.frame.size.height/2)]];
    
    [positionAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(self.box.layer.frame.origin.x + self.box.layer.frame.size.width/2, self.box.layer.frame.size.height/2 + self.navigationController.navigationBar.frame.size.height)]];
    positionAnimation.autoreverses = YES;
    
    [positionAnimation setDuration:10.0];
    [positionAnimation setBeginTime:0.0];
    
    CABasicAnimation *fadeInAndOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAndOut.duration = 2.0;
    fadeInAndOut.autoreverses = YES;
    fadeInAndOut.fromValue = [NSNumber numberWithFloat:1.0];
    fadeInAndOut.toValue = [NSNumber numberWithFloat:0.2];
    fadeInAndOut.repeatCount = HUGE_VALF;
    fadeInAndOut.fillMode = kCAFillModeBoth;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setDuration:10.0];
    group.autoreverses = YES;
    [group setAnimations:[NSArray arrayWithObjects: positionAnimation, fadeInAndOut, nil]];
    [self.box.layer addAnimation:group forKey:nil];
    
    
}


- (void) applyPathAnimation{
    
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath,NULL,74.0,74.0);
    CGPathAddCurveToPoint(thePath,NULL,
                          74.0,500.0,
                          320.0,500.0,
                          320.0,74.0);
    CGPathAddCurveToPoint(thePath,NULL,
                          320.0,500.0,
                          566.0,500.0,
                          566.0,74.0);
    
    CAKeyframeAnimation * theAnimation;
    
    theAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    theAnimation.path=thePath;
    theAnimation.duration=5.0;
    
    [self.box.layer addAnimation:theAnimation forKey:@"position"];

    
}

@end

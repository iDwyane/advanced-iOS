//
//  ViewController.m
//  Transitions_Demo
//
//  Created by Dwyane on 2017/10/20.
//  Copyright © 2017年 DWade. All rights reserved.
//

#import "ViewController.h"
typedef enum _AnimationDirection {
    positive  = 1,
    negative = -1,
} AnimationDirection;


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (nonatomic, assign) AnimationDirection direction;
@property (weak, nonatomic) IBOutlet UIImageView *planeImage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _direction = positive;
    [self changeFlight];
}

- (void)cubeTransitionWithLab:(UILabel *)label text:(NSString *)text direction:(AnimationDirection)direction{
    UILabel *auxLabel = [[UILabel alloc] initWithFrame:label.frame];
    auxLabel.text = text;
    auxLabel.font = label.font;
    auxLabel.textAlignment = label.textAlignment;
    auxLabel.textColor = label.textColor;
    auxLabel.backgroundColor = label.backgroundColor;
//    auxLabel.backgroundColor = [UIColor redColor];
    //offset
    CGFloat auxLabelOffset = (CGFloat)direction *
    auxLabel.frame.size.height/2.0;
    auxLabel.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0.0, auxLabelOffset), 1.0, 0.1);
    [label.superview addSubview:auxLabel];
[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    auxLabel.transform = CGAffineTransformIdentity;
    label.transform =  CGAffineTransformScale(CGAffineTransformMakeTranslation(0.0, -auxLabelOffset), 1.0, 0.1);
} completion:^(BOOL finished) {
    label.text = auxLabel.text;
    label.transform = CGAffineTransformIdentity;
    [auxLabel removeFromSuperview];
}];
}


- (void)changeFlight {
    
    
    [self planeDepart];
    
    _direction = (CGFloat)(_direction != positive) ? positive : negative;
    CGFloat direction = _direction;
    NSString *str = @"我是靓仔";
    if (_direction != positive) {
        str = @"我不靓仔";
    }
    
    
    [self cubeTransitionWithLab:self.lab text:str direction: direction];

    double delayInSeconds = 3.0;
    __block ViewController* bself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));

    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [bself changeFlight];
    });
}

- (void)planeDepart {
    
    CGPoint originalCenter = self.planeImage.center;
    [UIView animateKeyframesWithDuration:1.5 delay:0.0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.25 animations:^{
            CGPoint center = self.planeImage.center;
            center.x -= 80;
            center.y += 10;
            self.planeImage.center = center;
//            self.planeImage.center.x += 80;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.1 relativeDuration:0.4 animations:^{
            self.planeImage.transform = CGAffineTransformMakeRotation(-M_PI / 8);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.25 animations:^{
            CGPoint center = self.planeImage.center;
            center.x -= 100;
            center.y -= 50;
            self.planeImage.center = center;
            self.planeImage.alpha = 0.0;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.51 relativeDuration:0.01 animations:^{
            self.planeImage.transform = CGAffineTransformIdentity;
            
            CGPoint center = self.planeImage.center;
            center.x = 0.0;
            center.y = originalCenter.y;
            self.planeImage.center = center;
            
        }];
        
        
        [UIView addKeyframeWithRelativeStartTime:0.55 relativeDuration:0.45 animations:^{
            self.planeImage.alpha = 1.0;
            CGPoint center = self.planeImage.center;
            center = originalCenter;
            self.planeImage.center = center;
        }];
        
    } completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ViewController.m
//  Paticel Emitters
//
//  Created by Dwyane on 2017/10/18.
//  Copyright © 2017年 DWade. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置layer的frame
    CAEmitterLayer *emitter = [CAEmitterLayer new];
    CGRect frame = CGRectMake(0, -70, self.view.frame.size.width, 50);
    emitter.frame = frame;
    [self.view.layer addSublayer:emitter];
    
    //发射体的形状通常会影响到新粒子的产生，但也会影响到它们的z位置，在你创造3d粒子系统的情况下。
    emitter.emitterShape = kCAEmitterLayerRectangle;
    
//    Point shape
//    一个发射器形状的kCAEmitterLayerPoint使所有的粒子在同一点产生:发射器的位置。这是一个很好的选择，包括火花或烟花:
//    举例来说，你可以通过在同一点上创建所有的粒子并在它们消失之前让它们飞向不同的方向，从而产生火花效应。
    
    //Line shape
//    一个发射器形状的kCAEmitterLayerLine在发射器框架的顶部创建了所有的粒子。这是一个对瀑布效应有用的发射器形状;水颗粒出现在瀑布的顶部边缘，像这样瀑布向下。

//    Adding an emitter frame
    //结合形状、位置和大小属性定义了发射器框架。将发射器的位置设置为该层的中心，并设置发射器大小等于该层的大小。
    emitter.emitterPosition = CGPointMake(frame.size.width/2, frame.size.height/2);
    emitter.emitterSize = frame.size;
    
    CAEmitterCell *emitterCell = [[CAEmitterCell alloc] init];
    emitterCell.contents = (__bridge id)[UIImage imageNamed:@"flake"].CGImage;
    emitterCell.birthRate = 150;  //每秒创建20个雪花
    emitterCell.lifetime = 3.5;  //在屏幕上保持3.5秒
    emitterCell.lifetimeRange = 1.0; //2.5-5
    //添加颗粒模板到发射器
    emitter.emitterCells = @[emitterCell];
    
    emitterCell.yAcceleration = 70.0;
    emitterCell.xAcceleration = 10.0;
    emitterCell.velocity = 20.0;
    emitterCell.emissionLongitude = (CGFloat)-M_PI;
    emitterCell.velocityRange = 200.0; //带有负初始速度的粒子根本不会飞起来，而是浮起来
    emitterCell.emissionRange = (CGFloat)M_PI_2;
    emitterCell.color = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
    
//    emitterCell.redRange = 0.3;
//    emitterCell.greenRange = 0.3;
//    emitterCell.blueRange = 0.3;
    emitterCell.redRange = 0.1;
    emitterCell.greenRange = 0.1;
    emitterCell.blueRange = 0.1;
    
    emitterCell.scale = 0.8;
    emitterCell.scaleRange = 0.8;
    
    emitterCell.scaleSpeed = -0.15;
    
    emitterCell.alphaRange = 0.75; // 0.25-1.0
    emitterCell.alphaSpeed = -0.15; //逐渐消逝
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

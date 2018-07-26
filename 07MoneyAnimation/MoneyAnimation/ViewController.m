//
//  ViewController.m
//  MoneyAnimation
//
//  Created by Dwyane on 2018/7/23.
//  Copyright © 2018年 DW. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+MoneyAnimation.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = @"188969";
    double a = [str doubleValue]/100;
    NSString * num1 = [NSString stringWithFormat:@"%.2lf",a];
    [_moneyLabel dw_setNumber:@([num1 doubleValue])];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

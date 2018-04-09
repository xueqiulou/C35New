//
//  SuccessViewController.m
//  CV98
//
//  Created by TimeMachine on 2018/4/9.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import "SuccessViewController.h"

@interface SuccessViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *greatL;

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = @[@"Great!",@"Good Job!",@"Excellent!",@"Perfect!"];
    
    self.iconView.image = [UIImage imageNamed:self.img];
    self.nameL.text = self.name;
    self.greatL.text = arr[(arc4random()%4)];
    self.greatL.font = [UIFont fontWithName: @"MarkerFelt-Thin" size: 35];
//    [self.nextButton setBackgroundImage:[[UIImage imageNamed:@"next.png"] imageWithColor:[UIColor orangeColor]] forState:UIControlStateNormal];
    
}

- (IBAction)close:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)next:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end

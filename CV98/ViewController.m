//
//  ViewController.m
//  CV98
//
//  Created by TimeMachine on 2018/4/8.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import "ViewController.h"
#import "GamingViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIButton *easyB;
@property (weak, nonatomic) IBOutlet UIButton *mediumB;
@property (weak, nonatomic) IBOutlet UIButton *hardB;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpeg"]] colorWithAlphaComponent:0.5];
    
    UIView *bgVIew = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgVIew.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    
    self.titleL.font = [UIFont fontWithName: @"MarkerFelt-Thin" size: 35];
    
    self.easyB.titleLabel.font = [UIFont fontWithName: @"MarkerFelt-Thin" size: 35];
    self.easyB.layer.cornerRadius = 5;
    self.mediumB.titleLabel.font = [UIFont fontWithName: @"MarkerFelt-Thin" size: 35];
    self.mediumB.layer.cornerRadius = 5;
    self.hardB.titleLabel.font = [UIFont fontWithName: @"MarkerFelt-Thin" size: 35];
    self.hardB.layer.cornerRadius = 5;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIButton *button = sender;
    GamingViewController *gameVC = segue.destinationViewController;
    if ([button.currentTitle isEqualToString:@"EASY"]) {
        gameVC.fileName = @"easy";
    }
    if ([button.currentTitle isEqualToString:@"MEDIUM"]) {
        gameVC.fileName = @"medium";
    }
    if ([button.currentTitle isEqualToString:@"HARD"]) {
        gameVC.fileName = @"hard";
    }
}


@end

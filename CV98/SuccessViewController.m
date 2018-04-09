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

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iconView.image = [UIImage imageNamed:self.img];
    self.nameL.text = self.name;
    
}

- (IBAction)close:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end

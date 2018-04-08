//
//  GamingViewController.m
//  CV98
//
//  Created by TimeMachine on 2018/4/8.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import "GamingViewController.h"

@interface GamingViewController ()
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UILabel *answerL;

@end

@implementation GamingViewController
{
    NSMutableArray *arr;//26个字母的数组
    NSString *question;
    NSInteger i;
    NSMutableString *answerStr;
    NSDictionary *currentQuestionDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    answerStr = @"".mutableCopy;
    
    arr = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"].mutableCopy;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FruitsWords" ofType:@"plist"];
    NSArray *words = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    NSLog(@"%@",words);
    
    currentQuestionDic = words.lastObject;
    question = currentQuestionDic[@"name"];
    
    [self createCharatorButton:question.length superView:self.questionView];
    
    
}

-(void)createCharatorButton:(NSInteger)index superView:(UIView *)superView
{
    NSMutableArray *characterArr = @[].mutableCopy;
    for(int i =0; i < [question length]; i++){//遍历字符串中的字母,放到一个数组里
        
        NSString *temp = [question substringWithRange:NSMakeRange(i,1)];
        
        [characterArr addObject:temp];
        
    }
    
    for (int j=0; j<26-index; j++) {//随机插入混淆字母
        NSInteger index_ = arc4random()%26;
        NSString *confusionStr = arr[index_];
        
        index_ = arc4random()%index;
        [characterArr insertObject:confusionStr atIndex:index_];
    }
    
    for (int i=0; i<characterArr.count; i++) {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = (screenSize.width-lineSpace*2-lineSpace*8)/9;
        CGFloat height = width;
        btn.frame = CGRectMake(lineSpace+(lineSpace+width)*(i%9), 20+(lineSpace+height)*(i/9), width, height);
        //        btn.backgroundColor = [UIColor redColor];
        btn.tag = 100+i;
        [btn setBackgroundColor:[UIColor orangeColor]];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:25];

        [btn setTitle:characterArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectOneCharacter:) forControlEvents:UIControlEventTouchUpInside withSoundType:SoundTypeCard];
        [superView addSubview:btn];
    }
}

-(void)selectOneCharacter:(MyButton *)button
{
    [answerStr appendString:button.currentTitle];
    NSLog(@"%@",answerStr);
    
    if ([answerStr isEqualToString:question]) {
        NSLog(@"拼写成功");//过关,显示下一关
    }
    
    self.answerL.text = answerStr;
    
}
- (IBAction)refresh:(UIButton *)sender {
    
    self.answerL.text = nil;
    
    answerStr = @"".mutableCopy;
    
}
- (IBAction)undo:(UIButton *)sender {
    
    if (answerStr.length) {
        [answerStr deleteCharactersInRange:NSMakeRange(answerStr.length-1, 1)];
        self.answerL.text = answerStr;
    }
    
}


@end

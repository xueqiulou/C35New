//
//  GamingViewController.m
//  CV98
//
//  Created by TimeMachine on 2018/4/8.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import "GamingViewController.h"
#import "SuccessViewController.h"
#import <AVFoundation/AVFoundation.h>


static NSInteger characterCount = 10;
static NSInteger columnCount = 5;

@interface GamingViewController ()
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UILabel *answerL;
@property (nonatomic,strong) UIButton *tipsB;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation GamingViewController
{
    NSMutableArray *arr;//26个字母的数组
    NSString *question;
    NSInteger i;
    NSMutableString *answerStr;
    NSDictionary *currentQuestionDic;
    NSInteger stageCount;
    NSArray *words;
    SystemSoundID soundFileObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    answerStr = @"".mutableCopy;
    
    arr = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"].mutableCopy;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"plist"];
    words = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    NSLog(@"%@",words);
    
    currentQuestionDic = words.firstObject;
    question = currentQuestionDic[@"name"];
    
    self.iconView.image = [UIImage imageNamed:currentQuestionDic[@"img"]];
    
    [self createCharatorButton:question.length superView:self.questionView];
    
    [self customNavigationView];
}


-(void)customNavigationView
{
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 74)];
    navigationView.backgroundColor = [UIColor clearColor];
    
    MyButton *backB = [MyButton buttonWithType:UIButtonTypeCustom];
    backB.frame = CGRectMake(15, 30, 50, 40);
    [backB setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backB addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationView addSubview:backB];
    
    
    MyButton *tipsB = [MyButton buttonWithType:UIButtonTypeCustom];
    self.tipsB = tipsB;
    tipsB.frame = CGRectMake(navigationView.xql_width-50, 25, 50, 50);
    [tipsB setBackgroundImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
    [tipsB addTarget:self action:@selector(tips:) forControlEvents:UIControlEventTouchUpInside];

    
    [navigationView addSubview:tipsB];
    
    
    UIButton *refreshB = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshB.frame = CGRectMake(tipsB.xql_left-50, 25, 50, 50);
    [refreshB setBackgroundImage:[[UIImage imageNamed:@"refresh.png"] imageWithColor:[UIColor orangeColor]] forState:UIControlStateNormal];
    [refreshB addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationView addSubview:refreshB];
    
    
    [self.view addSubview:navigationView];
}

-(void)back:(MyButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tips:(MyButton *)sender
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:question message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self refresh:nil];
//    }];
//    [alertVC addAction:sure];
    [self presentViewController:alertVC animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertVC dismissViewControllerAnimated:YES completion:nil];
    });
}

-(void)createCharatorButton:(NSInteger)index superView:(UIView *)superView
{
    NSMutableArray *characterArr = @[].mutableCopy;
    for(int i =0; i < [question length]; i++){//遍历字符串中的字母,放到一个数组里
        
        NSString *temp = [question substringWithRange:NSMakeRange(i,1)];
        
        [characterArr addObject:temp];
        
    }
    
    for (int j=0; j<characterCount-index; j++) {//随机插入混淆字母
        NSInteger index_ = arc4random()%26;
        NSString *confusionStr = arr[index_];

        index_ = arc4random()%index;
        [characterArr insertObject:confusionStr atIndex:index_];
    }
    
    
    characterArr = (NSMutableArray *)[characterArr sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {  
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    
    for (int i=0; i<characterArr.count; i++) {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = (screenSize.width-lineSpace*2-lineSpace*(columnCount-1))/columnCount;
        CGFloat height = width;
        btn.frame = CGRectMake(lineSpace+(lineSpace+width)*(i%columnCount), 20+(lineSpace+height)*(i/columnCount), width, height);
        //        btn.backgroundColor = [UIColor redColor];
        btn.tag = 100+i;
        [btn setBackgroundColor:[UIColor orangeColor]];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
        btn.layer.cornerRadius = width*0.5;
        btn.layer.shadowColor = [UIColor blackColor].CGColor;
        btn.layer.shadowOffset = CGSizeMake(2, 2);
        

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
        [self playdSoulndEffrect:@"success" type:nil];
        [self performSegueWithIdentifier:@"success" sender:nil];
        stageCount++;
        currentQuestionDic = words[stageCount];
        question = currentQuestionDic[@"name"];
        [self showNewQuestion];
    }else{
        if (answerStr.length==question.length) {
            [self playdSoulndEffrect:@"wrong" type:nil];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Please try again" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self refresh:nil];
            }];
            [alertVC addAction:sure];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }
    
    self.answerL.text = answerStr;
    
}

-(void)showNewQuestion
{
    for (UIView *subView in self.questionView.subviews) {
        [subView removeFromSuperview];
    }
    answerStr = @"".mutableCopy;
    self.answerL.text = answerStr;
    self.iconView.image = [UIImage imageNamed:currentQuestionDic[@"img"]];
    [self createCharatorButton:question.length superView:self.questionView];
}

- (IBAction)refresh:(UIButton *)sender {
    
    self.answerL.text = nil;
    
    answerStr = @"".mutableCopy;
    
}
- (IBAction)undo:(UIButton *)sender {
    
    if (answerStr.length) {
        [self playdSoulndEffrect:@"card" type:nil];
        [answerStr deleteCharactersInRange:NSMakeRange(answerStr.length-1, 1)];
        self.answerL.text = answerStr;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SuccessViewController *vc = segue.destinationViewController;
    vc.name = question;
    vc.img = currentQuestionDic[@"img"];
    
}


- (void)playdSoulndEffrect:(NSString*)name type:(NSString*)type

{
    
    //得到音效文件的地址
    
    NSString*soundFilePath =[[NSBundle mainBundle]pathForResource:name ofType:@"mp3"];
    
    //将地址字符串转换成url
    
    NSURL*soundURL = [NSURL fileURLWithPath:soundFilePath];
    
    //生成系统音效id
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &soundFileObject);
    
    //播放系统音效
    
    AudioServicesPlaySystemSound(soundFileObject);
    
}

@end

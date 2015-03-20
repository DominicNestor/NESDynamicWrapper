//
//  NESMainViewController.m
//  NESDynamicWrapper
//
//  Created by Nestor on 15/3/12.
//  Copyright (c) 2015年 NesTalk. All rights reserved.
//

#import "NESMainViewController.h"
#import "NESTestView.h"

@interface NESMainViewController ()

@property (nonatomic,retain) NESTestView *testView;

@end

@implementation NESMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.testView = [[NESTestView alloc] initWithFrame:CGRectMake(10, 30, 300, 30)];
    self.testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.testView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10, 70, 300, 30);
    [btn setTitle:@"Show/Hidden" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view.
}

-(void)tapped:(UIButton *)sender
{
    static int hidden = 0;
    if (hidden)
    {
        [self.testView show];
        printf("//////////////////////////////////////\n");
    }
    else
    {
        [self.testView hide];
        printf("//////////////////////////////////////\n"); 
    }
    
    hidden = !hidden;
    
    [self.testView test];
    printf("//////////////////////////////////////\n");
    
    NSString *ret = [self.testView print:@"a string"];
    NSLog(@"return string is:%@",ret);
    printf("//////////////////////////////////////\n");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
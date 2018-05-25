//
//  TXtestViewController.m
//  TailorX
//
//  Created by Qian Shen on 26/9/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXtestViewController.h"

@interface TXtestViewController ()

@end

@implementation TXtestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.coverImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_HEIGHT, 300)];
    self.coverImgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.coverImgView];
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

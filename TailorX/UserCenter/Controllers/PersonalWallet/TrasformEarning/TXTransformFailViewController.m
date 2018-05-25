//
//  TXTransformSuccessViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/5/31.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXTransformFailViewController.h"

@interface TXTransformFailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *turnOut;
@property (weak, nonatomic) IBOutlet UILabel *income;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;

@end

@implementation TXTransformFailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"转出收益";
    
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
- (IBAction)rechargeAction:(id)sender {
    
}

@end

//
//  TXUserFeedBackViewController.m
//  TailorX
//
//  Created by 温强 on 2017/3/23.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXUserFeedBackViewController.h"

@interface TXUserFeedBackViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *textViewPlaceHolderLab;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) ThemeButton *sureBtn;
@property (nonatomic, strong) UILabel *strLenthLab;
@end

@implementation TXUserFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    self.view.backgroundColor = RGB(240, 240, 240);
    [self setUpUI];
    
}

#pragma mark --UI

- (void)setUpUI {
    
    UIView * baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, 250)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    _textView = [[UITextView alloc] init];
    _textView.tintColor = RGB(51, 51, 51);
    _textView.font = FONT(14);
    _textView.delegate = self;
    [baseView addSubview:_textView];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baseView).offset(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(@(150));
    }];
    
    _textViewPlaceHolderLab = [[UILabel alloc] init];
    _textViewPlaceHolderLab.enabled = NO;
    _textViewPlaceHolderLab.font = FONT(14);
    _textViewPlaceHolderLab.textColor = RGB(153, 153, 153);
    _textViewPlaceHolderLab.text = @"写下你的宝贵意见和建议";
    [baseView addSubview:_textViewPlaceHolderLab];
    [_textViewPlaceHolderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(19);
    }];
    
    UIView *strLenthLabBgView = [UIView viewWithBgColor:[UIColor whiteColor] superView:self.view];
    [strLenthLabBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baseView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@30);
    }];
    
    self.strLenthLab = [UILabel labelWithFont:14.0
                                    textColor:RGB(153, 153, 153)
                                         text:@"0/150"
                                    superView:strLenthLabBgView];
    
    self.strLenthLab.textAlignment = NSTextAlignmentRight;
    [self.strLenthLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(strLenthLabBgView).offset(10);
        make.left.equalTo(strLenthLabBgView).offset(15);
        make.right.equalTo(strLenthLabBgView).offset(-15);
    }];
    
    self.sureBtn = [TailorxFactory setBlackThemeBtnWithTitle:@"提交"];
    self.sureBtn.titleLabel.font = FONTType(@"STHeitiSC-Medium", 15);
    [self.view addSubview:self.sureBtn];
    [self.sureBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn.enabled = NO;
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@60);
    }];
    
}




#pragma mark --UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.sureBtn.enabled = NO;
        _textViewPlaceHolderLab.text = @"写下你的宝贵意见和建议";
    }else{
        self.sureBtn.enabled = YES;
        _textViewPlaceHolderLab.text = @"";
    }
    
    NSString * strLent = [_textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strLent = [strLent stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.strLenthLab.text = [NSString stringWithFormat:@"%lu/150",(unsigned long)strLent.length];
    
    if (strLent.length > 150) {
    
    }
    
}
- (void)submit {
    [self.view endEditing:YES];
    // 判断是不是全是空格或者回车
    NSString * strLent = [_textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strLent = [strLent stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (strLent.length == 0) {

        
        
    } else {
         [MBProgressHUD showSuccess:@"提交成功"];
    }
   

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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

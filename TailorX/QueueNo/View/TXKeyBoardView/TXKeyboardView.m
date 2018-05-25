//
//  TXKeyboardView.m
//  TailorX
//
//  Created by liuyanming on 2017/3/20.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXKeyboardView.h"
#import "TXKeyboardBar.h"

#define kKeyboardBarH 47
#define kKeyboardH 216

@interface TXKeyboardView () <UITextFieldDelegate>

@property (strong, nonatomic) UIView *cover;

@property (assign, nonatomic) CGFloat height;

@property (nonatomic, strong) UIView *keyboard;

@property (nonatomic, weak) TXKeyboardBar *keyboardBar;

@property (nonatomic, weak) UIButton *confirm;

@property (nonatomic, copy) NSString *resultString;

@end

@implementation TXKeyboardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setParam:(TXQueueNoRequestParams *)param  {
    _param = param;
    self.keyboardBar.rightTextField.text = [NSString stringWithFormat:@"￥%.2f",param.amount];
    
    if (param.amount == 0.0) {
        self.keyboardBar.rightTextField.hidden = true;
        self.keyboardBar.midLine.hidden = true;
        self.keyboardBar.rightLabel.hidden = true;
        self.keyboardBar.rightMiddleView.hidden = true;
    } else {
        self.keyboardBar.rightTextField.hidden = false;
        self.keyboardBar.midLine.hidden = false;
        self.keyboardBar.rightLabel.hidden = false;
        self.keyboardBar.rightMiddleView.hidden = false;
    }
}

- (void)setup {
    
    self.height = kKeyboardBarH + kKeyboardH;
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.height);
    
    // 遮盖
    _cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [_cover addSubview:self];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 9527;
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(0, 0, _cover.frame.size.width, _cover.frame.size.height-kKeyboardH);
    [btn addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    [_cover addSubview:btn];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_cover];
    
    [self addkeyboardBar];
    [self addKeyboard];
}

// 初始化Bar
- (void)addkeyboardBar {
    TXKeyboardBar *keyboardBar = [TXKeyboardBar instanse];
    keyboardBar.backgroundColor = [UIColor whiteColor];
    keyboardBar.frame = CGRectMake(0, 0, self.frame.size.width, kKeyboardBarH);
    keyboardBar.leftTextField.delegate = self;
    [self addSubview:keyboardBar];
    
    self.keyboardBar = keyboardBar;

    self.resultString = [[NSString alloc] init];
}

// 初始化键盘
- (void)addKeyboard {
    UIView *keyboard = [[UIView alloc] initWithFrame:CGRectMake(0, kKeyboardBarH, self.frame.size.width, kKeyboardH)];
    keyboard.backgroundColor = RGB(221, 221, 221);

    self.keyboard = keyboard;
    [self initKeyBoardNumber];
    
    self.keyboardBar.leftTextField.inputView = self.keyboard;
    [self.keyboardBar.leftTextField reloadInputViews];
}

// 初始化键盘按钮
- (void)initKeyBoardNumber {
    
    CGFloat space=1;
    CGFloat btnw = (self.frame.size.width - 4*space)/ 4 ;
    CGFloat btnh = (kKeyboardH - 3*space) / 4 ;
    
    for (int i=0; i<9; i++) {
        
        NSString *str=[NSString stringWithFormat:@"%d",i+1];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
        
        if (i<3) {
            button.frame = CGRectMake(i%3*(btnw+space), i/3*(btnh+space)+1, btnw, btnh-1);
        }
        else{
            button.frame = CGRectMake(i%3*(btnw+space), i/3*btnh+i/3*space, btnw, btnh);
        }
        button.backgroundColor=[UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:24];
        [button setTitle:str forState:UIControlStateNormal];
        button.tag=i+1;
        [button addTarget:self action:@selector(keyBoardAciont:) forControlEvents:UIControlEventTouchUpInside];
        [self.keyboard addSubview:button];
    }
    
    UIButton *dian = [UIButton buttonWithType:UIButtonTypeSystem];
    dian.frame = CGRectMake(0,btnh*3+space*3 , btnw, btnh);
    dian.backgroundColor = [UIColor whiteColor];
    [dian setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dian.titleLabel.font = [UIFont systemFontOfSize:24];
    [dian addTarget:self action:@selector(keyBoardAciont:) forControlEvents:UIControlEventTouchUpInside];
    [dian setTitle:@"." forState:UIControlStateNormal];
    dian.tag=11;
    [self.keyboard addSubview:dian];
    
    UIButton *ling = [UIButton buttonWithType:UIButtonTypeSystem];
    ling.frame = CGRectMake(btnw+space,btnh*3+space*3, btnw, btnh);
    ling.backgroundColor = [UIColor whiteColor];
    [ling setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ling.titleLabel.font = [UIFont systemFontOfSize:24];
    [ling setTitle:@"0" forState:UIControlStateNormal];
    ling.tag = 0;
    [ling addTarget:self action:@selector(keyBoardAciont:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboard addSubview:ling];
    
    UIButton *computer = [UIButton buttonWithType:UIButtonTypeSystem];
    computer.frame = CGRectMake(btnw*2+space*2,btnh*3+space*3, btnw, btnh);
    computer.backgroundColor = [UIColor whiteColor];
    [computer setImage:[UIImage imageNamed:@"ic_main_keyboard"] forState:UIControlStateNormal];
    computer.tag = 12;
    [computer addTarget:self action:@selector(keyBoardAciont:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboard addSubview:computer];
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeSystem];
    delete.frame = CGRectMake(btnw*3+space*3,1, btnw+space, btnh*2+space-1);
    delete.backgroundColor = [UIColor whiteColor];
    [delete addTarget:self action:@selector(keyBoardAciont:) forControlEvents:UIControlEventTouchUpInside];
    delete.tag = 10;
    
    [delete setImage:[UIImage imageNamed:@"ic_main_delete"] forState:UIControlStateNormal];
    [self.keyboard addSubview:delete];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
    confirm.frame = CGRectMake(btnw*3+space*3,btnh*2+space*2, btnw+space, btnh*2+space);
    confirm.backgroundColor = RGB(221, 221, 221);
    confirm.userInteractionEnabled = NO;
    [confirm setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    confirm.titleLabel.font=[UIFont systemFontOfSize:20];
    [confirm setTitle:@"确 定" forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(keyBoardAciont:) forControlEvents:UIControlEventTouchUpInside];
    confirm.tag = 13;
    self.confirm = confirm;
    [self.keyboard addSubview:confirm];
}

#pragma 键盘点击按钮事件
- (void)keyBoardAciont:(UIButton *)sender {
    
    UIButton* btn = (UIButton*)sender;
    NSInteger number = btn.tag;
    if (number <= 9 && number >= 0) {
        
        _resultString = [_resultString stringByAppendingString:[NSString stringWithFormat:@"%zd", number]];
        
        if (_resultString.length > 0) {
            self.confirm.backgroundColor = [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"];
            self.confirm.userInteractionEnabled = YES;
            
            NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,6}(([.]\\d{0,2})?)))?";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
            BOOL flag = [phoneTest evaluateWithObject:_resultString];
            if (!flag) {
                NSMutableString *muStr = [[NSMutableString alloc] initWithString:_resultString];

                [muStr deleteCharactersInRange:NSMakeRange([_resultString length] - 1, 1)];
                _resultString = muStr;
                self.keyboardBar.leftTextField.text = _resultString;

                return;
            } else {
              self.keyboardBar.leftTextField.text = _resultString;
            }
        }else {
            self.confirm.backgroundColor = RGB(221, 221, 221);
            self.confirm.userInteractionEnabled = NO;
        }
        return;
    }
    
    if (10 == number) { // 删除
        NSMutableString *muStr = [[NSMutableString alloc] initWithString:_resultString];
        if (muStr.length <= 0) {
            
        }else {
            [muStr deleteCharactersInRange:NSMakeRange([muStr length] - 1, 1)];
            _resultString = muStr;
            
            self.keyboardBar.leftTextField.text = _resultString;
            if (_resultString.length <= 0) {
                self.confirm.backgroundColor = RGB(221, 221, 221);
                self.confirm.userInteractionEnabled = NO;
            }else {
                self.confirm.backgroundColor = [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"];
                self.confirm.userInteractionEnabled = YES;
            }
            return;
        }
    }
    if (11 == number) { // 小数点
        if ([_resultString isEqualToString:@""]) {
            return;
        }
        //判断当前时候存在一个点
        if ([_resultString rangeOfString:@"."].location == NSNotFound) {
            //输入中没有点
            _resultString = [_resultString stringByAppendingString:@"."];
            self.keyboardBar.leftTextField.text = _resultString;
        }
        return;
    }
    if (12 == number) { // 退出键盘
        [self hidden];
        return;
    }
    
    if (13 == number) { // 确定
        if (!self.keyboardBar.leftTextField.hasText) {
            [ShowMessage showMessage:@"请输入转让金额" withCenter:_cover.center];
            return;
        }
        if ([self.keyboardBar.leftTextField.text floatValue] <= 0) {
            [ShowMessage showMessage:@"转让金额不能为0" withCenter:_cover.center];
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(keyboardSureBtnClick:)]) {
            [self.delegate keyboardSureBtnClick:self.keyboardBar.leftTextField.text];
        }
        return;
    }
}

#pragma mark - 显示隐藏
- (void)show {
//    [self setup];
    [UIView animateWithDuration:0.4 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -_height);
        [self.keyboardBar.leftTextField becomeFirstResponder];
    } completion:^(BOOL finished) {
        self.keyboardBar.rightTextField.text = [NSString stringWithFormat:@"￥%.2f",self.param.amount];
    }];
}

- (void)hidden {
    [UIView animateWithDuration:0.4 animations:^{
        [self.keyboardBar.leftTextField becomeFirstResponder];
        self.transform = CGAffineTransformIdentity;
        [self.keyboardBar removeFromSuperview];
        [self removeFromSuperview];
        [_cover removeFromSuperview];
    } completion:^(BOOL finished) {

    }];
}

// textField输入金额的正则判断  不能以空格开头、0以后只能是小数点、最多2位小数  符合金钱的规则
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toString.length > 0) {
        NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d*(([.]\\d{0,2})?)))?";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        BOOL flag = [phoneTest evaluateWithObject:toString];
        if (!flag) {
            return NO;
        }
    }
    return YES;
}


@end

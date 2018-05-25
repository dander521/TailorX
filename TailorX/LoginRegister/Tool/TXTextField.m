//
//  TXTextField.m
//  TailorX
//
//  Created by Qian Shen on 29/8/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXTextField.h"

@interface TXTextField ()<UITextFieldDelegate>

/** 注释*/
@property (nonatomic,strong) UILabel *placeholderLabel;
/** 注释信息普通状态下颜色*/
@property (nonatomic,strong) UIColor  *placeholderNormalStateColor;
/** 注释信息选中状态下颜色*/
@property (nonatomic,strong) UIColor  *placeholderSelectStateColor;
/** 移动一次*/
@property (nonatomic,assign) BOOL moved;

@end

@implementation TXTextField

static const CGFloat padding = 0;
static const CGFloat heightSpaceing = 0;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeInterface];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self initializeInterface];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.placeholderSelectStateColor = RGB(153, 153, 155);
        self.placeholderNormalStateColor = RGB(156, 156, 158);
    }
    return self;
}

- (void)initializeInterface {
    _textField = [[UITextField alloc]initWithFrame:CGRectZero];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.font = [UIFont systemFontOfSize:15.f];
    _textField.textColor = RGB(46, 46, 46);
    _textField.delegate = self;
    _textField.backgroundColor = [UIColor clearColor];
    [self addSubview:_textField];
    _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _placeholderLabel.font = [UIFont systemFontOfSize:15.f];
    _placeholderLabel.textColor = RGB(156, 156, 158);
    [self addSubview:_placeholderLabel];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(obserValue:) name:UITextFieldTextDidChangeNotification object:_textField];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textField.frame = CGRectMake(0, CGRectGetHeight(self.frame)-50, CGRectGetWidth(self.frame), 50);
    _placeholderLabel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-50, CGRectGetWidth(self.frame),50);
}

- (void)obserValue:(NSNotification *)obj {
    [self changeFrameOfPlaceholder];
}

- (void)changeFrameOfPlaceholder {
    CGFloat y = _placeholderLabel.center.y;
    CGFloat x = _placeholderLabel.center.x;
    if(_textField.text.length != 0 && !_moved) {
        [self moveAnimation:x y:y];
    }else if(_textField.text.length == 0 && _moved) {
        [self backAnimation:x y:y];
    }
}

- (void)moveAnimation:(CGFloat)x y:(CGFloat)y {
    __block CGFloat moveX = x;
    __block CGFloat moveY = y;
    _placeholderLabel.font = [UIFont systemFontOfSize:11.f];
    _placeholderLabel.textColor = self.placeholderSelectStateColor;
    [UIView animateWithDuration:0.15 animations:^ {
        moveY -= _placeholderLabel.frame.size.height/2 + heightSpaceing;
        moveX -= padding;
        _placeholderLabel.center = CGPointMake(moveX, moveY);
        _placeholderLabel.alpha = 1;
        _moved = YES;
    }];
}

- (void)backAnimation:(CGFloat)x y:(CGFloat)y {
    __block CGFloat moveX = x;
    __block CGFloat moveY = y;
    _placeholderLabel.font = [UIFont systemFontOfSize:15.f];
    _placeholderLabel.textColor = [UIColor darkGrayColor];
    [UIView animateWithDuration:0.15 animations:^{
        moveY += _placeholderLabel.frame.size.height/2 + heightSpaceing;
        moveX += padding;
        _placeholderLabel.center = CGPointMake(moveX, moveY);
        _placeholderLabel.alpha = 1;
        _moved = NO;
    }];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _placeholderLabel.text = _placeholder;
}

- (void)setPlaceholderNormalStateColor:(UIColor *)placeholderNormalStateColor {
    if(!placeholderNormalStateColor){
        _placeholderLabel.textColor = [UIColor darkGrayColor];
    }else{
        _placeholderLabel.textColor = placeholderNormalStateColor;
    }
}

- (void)setPlaceholderSelectStateColor:(UIColor *)placeholderSelectStateColor {
    if(!placeholderSelectStateColor){
        _placeholderSelectStateColor = [UIColor whiteColor];
    }else{
        _placeholderSelectStateColor = placeholderSelectStateColor;
    }
}

@end

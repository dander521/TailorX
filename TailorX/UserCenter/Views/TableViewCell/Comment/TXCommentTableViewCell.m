//
//  TXCommentTableViewCell.m
//  TailorX
//
//  Created by RogerChen on 20/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXCommentTableViewCell.h"


@interface TXCommentTableViewCell ()<UITextViewDelegate>


@end

@implementation TXCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    [self.inputTextView addPlaceholderWithText:@"请输入你的评价内容"
                                     textColor:[UIColor lightGrayColor]
                                          font:[UIFont systemFontOfSize:14.f]];
    self.inputTextView.tintColor = RGB(46, 46, 46);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXCommentTableViewCell";
    TXCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}


#pragma mark --UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
    NSString * strLent = [_inputTextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strLent = [strLent stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSRange range = [self.wordCountLabel.text rangeOfString:@"/"];
    NSRange resultRange = NSMakeRange(0, range.location);
  
    [UIView textView:_inputTextView maxLength:150 showEmoji:false];
    self.wordCountLabel.attributedText = [NSString setAttributedString:[NSString stringWithFormat:@"%lu/150",(unsigned long)_inputTextView.text.length] color:RGB(51, 51, 51) rang:resultRange font:FONT(8)];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end

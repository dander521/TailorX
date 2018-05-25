//
//  TXProductProgressTableViewCell.m
//  TailorX
//
//  Created by RogerChen on 21/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXProductProgressTableViewCell.h"

@implementation TXProductProgressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    NSArray *titles = @[LocalSTR(@"Str_TestCloth"),
                        LocalSTR(@"Str_Tail"),
                        LocalSTR(@"Str_Tailor"),
                        LocalSTR(@"Str_Ironing"),
                        LocalSTR(@"Str_Checkout"),
                        LocalSTR(@"Str_Packing")];;
    _customProgressView = [[TXCustomProgressView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width-23, 80) titles:titles];
    _customProgressView.customProgressViewColor = [UIColor blueColor];
    _customProgressView.currentColor = [UIColor redColor];
    _customProgressView.currentIndex = 5;
    [self.productProgressView addSubview:_customProgressView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXProductProgressTableViewCell";
    TXProductProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TXProductProgressTableViewCell class]) owner:self options:nil] lastObject];
        
    }
    
    return cell;
}


@end

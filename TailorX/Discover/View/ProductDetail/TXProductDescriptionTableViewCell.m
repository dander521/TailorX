//
//  TXProductDescriptionTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/8.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXProductDescriptionTableViewCell.h"
#import "UIView+SFrame.h"

@interface TXProductDescriptionTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsViewHeightLayout;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIView *tagsBgView;

@end

@implementation TXProductDescriptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TXProductDetailModel *)model {
    _model = model;

    self.priceLabel.text = [NSString stringWithFormat:@"￥ %@", model.price];
    
    NSMutableArray <TagsInfo *>*tempArray = [NSMutableArray new];
    [tempArray addObjectsFromArray:model.systemTags];
    [tempArray addObjectsFromArray:model.commonTags];
    
    [self.tagsBgView removeAllSubViews];
    CGFloat maxWidth = SCREEN_WIDTH - 93;

    if (tempArray.count == 0) {
        TagsInfo *tag = [TagsInfo new];
        tag.tagName = @"暂无标签";
        tempArray = [NSMutableArray arrayWithArray:@[tag]];
    }
    
    float btnW = 0;
    int count = 0;
    for (int i = 0; i < tempArray.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.borderColor = RGB(204, 204, 204);
        label.textColor = RGB(153, 153, 153);
        label.layer.borderWidth = 0.5f;
        label.layer.cornerRadius = 2.f;
        label.textAlignment = NSTextAlignmentCenter;
        CGFloat labelWidth = [self heightForString:tempArray[i].tagName fontSize:12 andWidth:maxWidth].width + 20;
        label.width = labelWidth;
        label.height = 22;
        if (i == 0) {
            label.x = 0;
            btnW += CGRectGetMaxX(label.frame);
        }
        else{
            btnW += CGRectGetMaxX(label.frame) + 10;
            if (btnW > maxWidth) {
                count++;
                label.x = 0;
                btnW = CGRectGetMaxX(label.frame);
            }
            else{
                label.x += btnW - label.width;
            }
        }
        label.y += count * (label.height + 10) + 10;
        label.text = tempArray[i].tagName;
        [self.tagsBgView addSubview:label];
//        if (i == tempArray.count - 1) {
//            self.tagsViewHeightLayout.constant = CGRectGetMaxY(label.frame);
//        }
    }
}

/**
 * 计算文字的宽高
 */
- (CGSize)heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width {
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize;
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXProductDescriptionTableViewCell";
    TXProductDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}


@end

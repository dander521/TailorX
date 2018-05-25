//
//  TXAddressTableViewCell.h
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXAddressModel.h"

typedef NS_ENUM(NSUInteger, TXAddressType) {
    TXAddressTypeDefault = 0, /** < 编辑 */
    TXAddressTypeEdit,
    TXAddressTypeOnlyStoreAddress
};

@protocol TXAddressTableViewCellDelegate <NSObject>

/**
 *  设置默认地址方法
 */
- (void)selectDefaultAddressButtonWithAddress:(TXAddressModel *)address;

/**
 *  编辑地址方法
 */
- (void)selectEditAddressButtonWithAddress:(TXAddressModel *)address;

/**
 *  删除地址方法
 */
- (void)selectDeleteAddressButtonWithAddress:(TXAddressModel *)address;

@end

@interface TXAddressTableViewCell : TXSeperateLineCell

/** 姓名 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 电话号码 */
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
/** 地址 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
/** 代理 */
@property (nonatomic, assign) id <TXAddressTableViewCellDelegate> delegate;
/** cell 类型 */
@property (nonatomic, assign) TXAddressType cellType;
/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;
/** 地址对象 */
@property (nonatomic, strong) TXAddressModel *address;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nameImageView;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;


/**
 配置地址

 @param address
 */
- (void)configAddressWithModel:(TXAddressModel *)address;

/**
 配置地址
 
 @param address
 */
- (void)configAddressWithName:(NSString *)name phoneNum:(NSString *)phoneNum address:(NSString *)address;

@end

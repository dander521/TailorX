//
//  TXProductDetailViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/8.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXProductDetailViewController.h"
#import "TXReservaDesingerViewController.h"

#import "TXProductDesTableViewCell.h"
#import "TXProductDescriptionTableViewCell.h"
#import "TXProductDesignerTableViewCell.h"

#import "TXProductImageTableViewCell.h"
#import "TXDesignRulesTableViewCell.h"
#import "TXMaterialTableViewCell.h"
#import "TXCustomerInfoTableViewCell.h"
#import "TXProductCommentTableViewCell.h"
#import "TXCustomerShowTableViewCell.h"
#import "TXProductSectionView.h"

#import "TXDesignerDetailController.h"

#import "TXProductDetailModel.h"
#import "UIView+SFrame.h"
#import "MSSBrowseModel.h"
#import "MSSBrowseNetworkViewController.h"

@interface TXProductDetailViewController ()<UITableViewDelegate, UITableViewDataSource, NetErrorViewDelegate, TXCustomerShowTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TXBlankView *blankView;
@property (nonatomic, strong) NetErrorView *netErrorView;

/** <#description#> */
@property (nonatomic, strong) TXProductDetailModel *model;

@end

@implementation TXProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    adjustsScrollViewInsets_NO(self.tableView, self);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.netErrorView];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Net Request

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:self.workId forKey:@"workId"];

    [TXNetRequest homeRequestMethodWithParams:param relativeUrl:strGetDesignerWorkDetail completion:^(id responseObject, NSError *error) {
        if (error) {
            [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
            [self.netErrorView stopNetViewLoadingFail:YES error:NO];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                [self.netErrorView stopNetViewLoadingFail:NO error:NO];
                
                self.model = [TXProductDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
                // 避免假数据造成 设计稿为空 正式环境没有问题
                if ([NSString isTextEmpty:self.model.designUrl]) {
                    self.model.designUrl = @"http://designUrl.jpg";
                }
                
                [UIView performWithoutAnimation:^{
                    self.navigationItem.rightBarButtonItems = [self customRightNavItems];
                    [self.tableView reloadData];
                }];
            }else{
                [ShowMessage showMessage:responseObject[kMsg]];
                [self.netErrorView stopNetViewLoadingFail:NO error:YES];
            }
        }
    }isLogin:^{
        [self.netErrorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger customerInfo = [NSString isTextEmpty:self.model.customerName] ? 0 : 1;
    NSInteger referanceInfo = [NSString isTextEmpty:self.model.referencePictures] ? 0 : 1;
    return 2 + customerInfo + referanceInfo;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        if ([NSString isTextEmpty:self.model.referencePictures]) {
            // 无客户信息
            if ([NSString isTextEmpty:self.model.customerName]) {
                NSArray *designArray = [self.model.designUrl componentsSeparatedByString:@","];
                return designArray.count;
            } else {
                // 设计稿
                if (section == 1) {
                    NSArray *designArray = [self.model.designUrl componentsSeparatedByString:@","];
                    return designArray.count;
                } else if (section == 2) {
                    // 客户信息
                    if (self.model.customerUpLoadPics.count == 0) {
                        return 3;
                    } else {
                        return 4;
                    }
                }
            }
        } else {
            // 参考图
            if (section == 1) {
                NSArray *referencePicturesArray = [self.model.referencePictures componentsSeparatedByString:@";"];
                return referencePicturesArray.count;
            } else {
                // 无客户信息
                if ([NSString isTextEmpty:self.model.customerName]) {
                    NSArray *designArray = [self.model.designUrl componentsSeparatedByString:@","];
                    return designArray.count;
                } else {
                    // 设计稿
                    if (section == 2) {
                        NSArray *designArray = [self.model.designUrl componentsSeparatedByString:@","];
                        return designArray.count;
                    } else if (section == 3) {
                        // 客户信息
                        if (self.model.customerUpLoadPics.count == 0) {
                            return 3;
                        } else {
                            return 4;
                        }
                    }
                }
            }
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *defaultCell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TXProductDesTableViewCell *cell = [TXProductDesTableViewCell cellWithTableView:tableView];
            cell.model = self.model;
            defaultCell = cell;
        } else if (indexPath.row == 1) {
            TXProductDescriptionTableViewCell *cell = [TXProductDescriptionTableViewCell cellWithTableView:tableView];
            cell.model = self.model;
            defaultCell = cell;
        } else {
            TXProductDesignerTableViewCell *cell = [TXProductDesignerTableViewCell cellWithTableView:tableView];
            cell.model = self.model;
            defaultCell = cell;
        }
    } else {
        if ([NSString isTextEmpty:self.model.referencePictures]) {
            // 无客户信息
            if ([NSString isTextEmpty:self.model.customerName]) {
                if (indexPath.section == 1) {
                    // 设计稿
                    NSArray *designArray = [self.model.designUrl componentsSeparatedByString:@","];
                    TXProductImageTableViewCell *cell = [TXProductImageTableViewCell cellWithTableView:tableView];
                    cell.imageUrl = designArray[indexPath.row];
                    defaultCell = cell;
                }
            } else {
                // 设计稿
                if (indexPath.section == 1) {
                    // 设计稿
                    NSArray *designArray = [self.model.designUrl componentsSeparatedByString:@","];
                    TXProductImageTableViewCell *cell = [TXProductImageTableViewCell cellWithTableView:tableView];
                    cell.imageUrl = designArray[indexPath.row];
                    defaultCell = cell;
                } else if (indexPath.section == 2) {
                    // 客户信息
                    if (indexPath.row == 0) {
                        TXCustomerInfoTableViewCell *cell = [TXCustomerInfoTableViewCell cellWithTableView:tableView];
                        cell.model = self.model;
                        defaultCell = cell;
                    } else if (indexPath.row == 1) {
                        TXDesignRulesTableViewCell *cell = [TXDesignRulesTableViewCell cellWithTableView:tableView];
                        cell.ruleArray = self.model.customerBodyList;
                        defaultCell = cell;
                    } else if (indexPath.row == 2) {
                        TXProductCommentTableViewCell *cell = [TXProductCommentTableViewCell cellWithTableView:tableView];
                        cell.model = self.model;
                        defaultCell = cell;
                    } else if (self.model.customerUpLoadPics.count > 0) {
                        TXCustomerShowTableViewCell *cell = [TXCustomerShowTableViewCell cellWithTableView:tableView];
                        cell.delegate = self;
                        cell.model = self.model;
                        defaultCell = cell;
                    }
                }
            }
        } else {
            // 参考图
            if (indexPath.section == 1) {
                NSArray *referencePicturesArray = [self.model.referencePictures componentsSeparatedByString:@";"];
                TXProductImageTableViewCell *cell = [TXProductImageTableViewCell cellWithTableView:tableView];
                cell.imageUrl = referencePicturesArray[indexPath.row];
                defaultCell = cell;
            } else {
                // 无客户信息
                if ([NSString isTextEmpty:self.model.customerName]) {
                    if (indexPath.section == 2) {
                        // 设计稿
                        NSArray *designArray = [self.model.designUrl componentsSeparatedByString:@","];
                        TXProductImageTableViewCell *cell = [TXProductImageTableViewCell cellWithTableView:tableView];
                        cell.imageUrl = designArray[indexPath.row];
                        defaultCell = cell;
                    }
                } else {
                    // 设计稿
                    if (indexPath.section == 2) {
                        // 设计稿
                        NSArray *designArray = [self.model.designUrl componentsSeparatedByString:@","];
                        TXProductImageTableViewCell *cell = [TXProductImageTableViewCell cellWithTableView:tableView];
                        cell.imageUrl = designArray[indexPath.row];
                        defaultCell = cell;
                    } else if (indexPath.section == 3) {
                        // 客户信息
                        if (indexPath.row == 0) {
                            TXCustomerInfoTableViewCell *cell = [TXCustomerInfoTableViewCell cellWithTableView:tableView];
                            cell.model = self.model;
                            defaultCell = cell;
                        } else if (indexPath.row == 1) {
                            TXDesignRulesTableViewCell *cell = [TXDesignRulesTableViewCell cellWithTableView:tableView];
                            cell.ruleArray = self.model.customerBodyList;
                            defaultCell = cell;
                        } else if (indexPath.row == 2) {
                            TXProductCommentTableViewCell *cell = [TXProductCommentTableViewCell cellWithTableView:tableView];
                            cell.model = self.model;
                            defaultCell = cell;
                        } else if (self.model.customerUpLoadPics.count > 0) {
                            TXCustomerShowTableViewCell *cell = [TXCustomerShowTableViewCell cellWithTableView:tableView];
                            cell.delegate = self;
                            cell.model = self.model;
                            defaultCell = cell;
                        }
                    }
                }
            }
        }
    }
    
    return defaultCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) return UITableViewAutomaticDimension;
        if (indexPath.row == 1) return [self getDesCellHeight];
        if (indexPath.row == 2) return UITableViewAutomaticDimension;
    } else {
        if ([NSString isTextEmpty:self.model.referencePictures]) {
            // 无客户信息
            if ([NSString isTextEmpty:self.model.customerName] && indexPath.section == 1) {
                // 设计稿
                NSArray *designArray = [self.model.designUrl componentsSeparatedByString:@","];
                NSString *imageUrl = designArray[indexPath.row];
                NSArray *hwArray = [self.model.picturesSize objectForKey:imageUrl];
                if (!hwArray || hwArray.count == 0) {
                    return 300;
                } else {
                    return [hwArray.firstObject floatValue]/[hwArray.lastObject floatValue]*(SCREEN_WIDTH-30)+20;
                }
            } else {
                // 设计稿
                if (indexPath.section == 1) {
                    // 设计稿
                    NSArray *designArray = [self.model.designUrl componentsSeparatedByString:@","];
                    NSString *imageUrl = designArray[indexPath.row];
                    NSArray *hwArray = [self.model.picturesSize objectForKey:imageUrl];
                    if (!hwArray || hwArray.count == 0) {
                        return 300;
                    } else {
                        return [hwArray.firstObject floatValue]/[hwArray.lastObject floatValue]*(SCREEN_WIDTH-30)+20;
                    }
                } else if (indexPath.section == 2) {
                    // 客户信息
                    if (indexPath.row == 0) return 65;
                    if (indexPath.row == 1) {
                        NSInteger bodyListCount = self.model.customerBodyList.count;
                        NSInteger row = bodyListCount/2;
                        NSInteger result = row + bodyListCount%2;
                        return result * 34 + 10;
                    };
                    if (indexPath.row == 2) return UITableViewAutomaticDimension;
                    if (indexPath.row == 3 && self.model.customerUpLoadPics.count > 0) return 200.0;
                }
            }
        } else {
            // 参考图
            if (indexPath.section == 1) {
                NSArray *referencePicturesArray = [self.model.referencePictures componentsSeparatedByString:@";"];
                // 参考图
                NSString *imageUrl = referencePicturesArray[indexPath.row];
                NSArray *hwArray = [self.model.picturesSize objectForKey:imageUrl];
                if (!hwArray || hwArray.count == 0) {
                    return 300;
                } else {
                    return [hwArray.firstObject floatValue]/[hwArray.lastObject floatValue]*(SCREEN_WIDTH-30)+20;
                }
            } else {
                // 无客户信息
                if ([NSString isTextEmpty:self.model.customerName] && indexPath.section == 2) {
                    // 设计稿
                    NSArray *designArray = [self.model.designUrl componentsSeparatedByString:@","];
                    NSString *imageUrl = designArray[indexPath.row];
                    NSArray *hwArray = [self.model.picturesSize objectForKey:imageUrl];
                    if (!hwArray || hwArray.count == 0) {
                        return 300;
                    } else {
                        return [hwArray.firstObject floatValue]/[hwArray.lastObject floatValue]*(SCREEN_WIDTH-30)+20;
                    }
                } else {
                    // 设计稿
                    if (indexPath.section == 2) {
                        // 设计稿
                        NSArray *designArray = [self.model.designUrl componentsSeparatedByString:@","];
                        NSString *imageUrl = designArray[indexPath.row];
                        NSArray *hwArray = [self.model.picturesSize objectForKey:imageUrl];
                        if (!hwArray || hwArray.count == 0) {
                            return 300;
                        } else {
                            return [hwArray.firstObject floatValue]/[hwArray.lastObject floatValue]*(SCREEN_WIDTH-30)+20;
                        }
                    } else if (indexPath.section == 3) {
                        // 客户信息
                        if (indexPath.row == 0) return 65;
                        if (indexPath.row == 1) {
                            NSInteger bodyListCount = self.model.customerBodyList.count;
                            NSInteger row = bodyListCount/2;
                            NSInteger result = row + bodyListCount%2;
                            return result * 34 + 10;
                        };
                        if (indexPath.row == 2) return UITableViewAutomaticDimension;
                        if (indexPath.row == 3 && self.model.customerUpLoadPics.count > 0) return 200.0;
                    }
                }
            }
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 0.01;
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TXProductSectionView *sectionView = [TXProductSectionView instanceView];
    if ([NSString isTextEmpty:self.model.referencePictures]) {
        if (section == 1) {
            sectionView.iconImageView.image = [UIImage imageNamed:@"ic_main_design_draft_3.3.0"];
            sectionView.desLabel.text = @"设计稿";
        }
        //    else if (section == 3) {
        //        sectionView.iconImageView.image = [UIImage imageNamed:@"ic_main_size_3.3.0"];
        //        sectionView.desLabel.text = @"设计尺寸";
        //    }
        else if (section == 2) {
            sectionView.iconImageView.image = [UIImage imageNamed:@"ic_main_customer_3.3.0"];
            sectionView.desLabel.text = @"客户信息";
        } else {
            return nil;
        }
    } else {
        if (section == 1) {
            sectionView.iconImageView.image = [UIImage imageNamed:@"ic_main_reference_shart_3.3.0"];
            sectionView.desLabel.text = @"参考图";
        } else if (section == 2) {
            sectionView.iconImageView.image = [UIImage imageNamed:@"ic_main_design_draft_3.3.0"];
            sectionView.desLabel.text = @"设计稿";
        }
        //    else if (section == 3) {
        //        sectionView.iconImageView.image = [UIImage imageNamed:@"ic_main_size_3.3.0"];
        //        sectionView.desLabel.text = @"设计尺寸";
        //    }
        else if (section == 3) {
            sectionView.iconImageView.image = [UIImage imageNamed:@"ic_main_customer_3.3.0"];
            sectionView.desLabel.text = @"客户信息";
        } else {
            return nil;
        }
    }
    
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 2) {
        TXDesignerDetailController *designerDetailVc = [[TXDesignerDetailController alloc] init];
        designerDetailVc.bEnterStoreDetail = YES;
        designerDetailVc.designerId = self.model.designerId;
        designerDetailVc.isHavaCommitBtn = YES;
        [self.navigationController pushViewController:designerDetailVc animated:YES];
    }
}

#pragma mark - Custom Method

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

- (CGFloat)getDesCellHeight {

    // 标签高度
    CGFloat tagsLabelHeight = 0;
    NSMutableArray <TagsInfo *>*tempArray = [NSMutableArray new];
    [tempArray addObjectsFromArray:self.model.systemTags];
    [tempArray addObjectsFromArray:self.model.commonTags];
    if (tempArray.count == 0) {
        TagsInfo *tag = [TagsInfo new];
        tag.tagName = @"暂无标签";
        tempArray = [NSMutableArray arrayWithArray:@[tag]];
    }
    CGFloat maxWidth = SCREEN_WIDTH - 93;
    float btnW = 0;
    int count = 0;
    UIView *tagBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    for (int i = 0; i < tempArray.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
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
        [tagBgView addSubview:label];
        if (i == tempArray.count - 1) {
            tagsLabelHeight = 3 + CGRectGetMaxY(label.frame);
        }
    }
    
    return tagsLabelHeight + 58;
}

- (NSArray *)customRightNavItems {
    UIButton *appointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [appointBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [appointBtn addTarget:self action:@selector(touchAppointmentBtn) forControlEvents:UIControlEventTouchUpInside];
    appointBtn.frame = CGRectMake(0, 0, 70, 30);
    appointBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [appointBtn setTitle:@"预约" forState:UIControlStateNormal];
    appointBtn.backgroundColor = RGB(246, 47, 94);
    appointBtn.layer.cornerRadius = 3.0;
    appointBtn.layer.masksToBounds = true;
    
    UIBarButtonItem *appointItem = [[UIBarButtonItem alloc]initWithCustomView:appointBtn];
    
//    UIBarButtonItem *customerServiceItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithOriginalName:@"ic_nav_customer_service"] style:UIBarButtonItemStylePlain target:self action:@selector(touchCustomerServiceBtn)];
//    return @[customerServiceItem, notificationItem];
    return @[appointItem];
}

#pragma mark - Touch Method

- (void)touchAppointmentBtn {
    if ([TXServiceUtil LoginController:(TXNavigationViewController*)self.navigationController]) {
        TXReservaDesingerViewController *vc = [TXReservaDesingerViewController new];
        vc.isHeadImgBtnClick = YES;
        vc.designerId = self.model.designerId;
        vc.customType = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    
}

#pragma mark --lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionIndexColor = RGB(0, 122, 255);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 500;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}


- (NetErrorView *)netErrorView {
    
    if (_netErrorView == nil) {
        _netErrorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _netErrorView.delegate = self;
    }
    return _netErrorView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TXCustomerShowTableViewCellDelegate

- (void)tapImageViewWithIndex:(NSUInteger)index photoArray:(NSArray *)photoArray cell:(TXCustomerShowTableViewCell *)cell {
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    for(int i = 0;i < [photoArray count];i++) {
        NSString *imagePath = photoArray[i];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = imagePath;// 加载网络图片大图地址
        
        if (i == 0) {
            browseItem.smallImageView = cell.firstImageView;
        } else if (i == 1) {
            browseItem.smallImageView = cell.secondImageView;
        } else {
            browseItem.smallImageView = cell.thirdImageView;
        }
        
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:index];
    [vwcBrowse showBrowseViewController];
}

@end

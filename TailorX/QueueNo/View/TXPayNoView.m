//
//  TXPayNoView.m
//  TailorX
//
//  Created by liuyanming on 2017/3/21.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXPayNoView.h"
#import "TXPayNoCell.h"
#import "TXFontTool.h"
#import "TXQueueNoRequestParams.h"

@interface TXPayNoView () <UITableViewDelegate, UITableViewDataSource>

/** 需要购买的排号 最上面的当view*/
@property (weak, nonatomic) IBOutlet ThemeLabel *ownNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/** 我的排号列表*/
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 付款金额*/
@property (weak, nonatomic) IBOutlet UILabel *payForMoneyLabel;
/** 付款按钮*/
@property (weak, nonatomic) IBOutlet ThemeButton *payBtn;
/** 请求我的排号列表参数*/
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageLength;
@property (nonatomic, assign) NSInteger dataCount;
/** UITableViewDataSource*/
@property (strong, nonatomic) NSMutableArray *dataArr;
/** 选中的行*/
@property (nonatomic, strong) NSIndexPath* selectIndexPath;
/** 阴影*/
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end

@implementation TXPayNoView

+ (instancetype)instanse {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    self.ownerLabel.layer.cornerRadius = 32;
    self.ownNumLabel.layer.cornerRadius = 32;
    
    self.shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    self.shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.shadowView.layer.shadowOpacity = 0.5;
    
    self.ownNumLabel.cloName = @"theme_color";
    
    _payBtn.cloNameN = @"theme_Btn_bg_color";
    _payBtn.cloNameH = @"theme_Btn_bg_color";
    _payBtn.titleCloNameN = @"theme_Btn_title_color";
    _payBtn.titleCloNameH = @"theme_Btn_title_color";
    
    _payForMoneyLabel.textColor = [[ThemeManager shareManager] loadThemeColorWithName:@"theme_color"];
    
    _page = 0;
    _pageLength = 10;
    
    [self addChildViews];
    
    [self loadData];
    
    self.selectIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];

}

- (void)addChildViews {
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 100;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    weakSelf(self);
    self.tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
        _page += 1;
        if (_dataCount < _pageLength) {
            [_tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }else {
            [weakSelf loadData];
        }
    }];
}

#pragma mark - request

- (void)loadData {
    
    TXQueueNoRequestParams *params = [TXQueueNoRequestParams param];
    params.page = _page;
    params.pageLength = _pageLength;
    params.saleStatus = 3;
    
    weakSelf(self);
    NSString *url = [strTailorxAPI stringByAppendingString:findMyRankNumList];
    
    [TXBaseNetworkRequset requestWithURL:url params:params.mj_keyValues success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
            
            TXQueueNoList *data = [TXQueueNoList mj_objectWithKeyValues:responseObject[ServerResponse_data]];
            weakSelf.dataCount = data.queueNos.count;
            
            if (!weakSelf.dataArr) {
                weakSelf.dataArr = [NSMutableArray arrayWithArray:data.queueNos];
            }else {
                [weakSelf.dataArr addObjectsFromArray:data.queueNos];
            }
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [ShowMessage showMessage:(NSString *)error];
        [weakSelf.tableView.mj_footer endRefreshing];
    } isLogin:^{
        
    }];
    
}

#pragma mark - setter

- (void)setData:(TXQueueNoModel *)data {
    _data = data;
    
    NSString *num = [NSString stringWithFormat:@"%ld号", (long)data.sortNo];
    _ownNumLabel.attributedText = [TXFontTool addFontAttribute:num minFont:MinFont number:1];
    
    _ownerLabel.text = data.userName;
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f", data.amount];
    
    _payForMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", data.amount];

}

/**
 * 付款
 */
- (IBAction)payforBtn:(UIButton *)sender {
    if (self.dataArr.count == 0) {
        [ShowMessage showMessage:@"您暂无可交易的排号" withCenter:[UIApplication sharedApplication].keyWindow.center];
        return;
    }
    if (self.selectIndexPath.row == -1) {
        [ShowMessage showMessage:@"请选择交换的排号" withCenter:[UIApplication sharedApplication].keyWindow.center];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(payForButtonAction:)]) {
        [self.delegate payForButtonAction:self.dataArr[self.selectIndexPath.row]];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXPayNoCell *cell = [TXPayNoCell cellWithTableView:tableView];
    cell.selectImgView.image = [UIImage imageNamed:@"ic_mian_select_no"];
    if (indexPath.row == _selectIndexPath.row) {
        cell.selectImgView.image = [[ThemeManager shareManager] loadThemeImageWithName:@"ic_mian_select_yes_red"];
    }
    if (self.dataArr.count) {
        cell.data = self.dataArr[indexPath.row];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectIndexPath = indexPath;
    [_tableView reloadData];
}

@end

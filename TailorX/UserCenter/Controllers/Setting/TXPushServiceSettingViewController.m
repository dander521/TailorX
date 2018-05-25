//
//  TXPushServiceSettingViewController.m
//  TailorX
//
//  Created by 温强 on 2017/3/29.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXPushServiceSettingViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "TXPushModel.h"

@interface TXPushServiceSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSArray<NSString*> *listAry;
@property (nonatomic, strong) TXPushModel *model;
@end

@implementation TXPushServiceSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推送设置";
    [self setUpmainTableView];
    
    // 获取用户的推送设置
    [self findSettings];
    
    self.model = [TXPushModel sharedTXPushModel];
}

- (void)findSettings {
    NSString *url = [strTailorxAPI stringByAppendingString:findSettings];
    weakSelf(self);
    [TXBaseNetworkRequset requestWithURL:url params:nil success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
            if (responseObject[ServerResponse_data]) {
                weakSelf.model = [TXPushModel mj_objectWithKeyValues:responseObject[ServerResponse_data]];
                [weakSelf.mainTableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [ShowMessage showMessage:error.description withCenter:self.view.center];
    } isLogin:^{
        
    }];
}

- (void)setUpmainTableView {
    
    self.mainTableView = [UITableView tableWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)
                                               style:UITableViewStylePlain
                                           superView:self.view];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - tableView delegate/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"pushSettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.textLabel.text = self.listAry[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    [self setUpSwitchWithIndex:indexPath.row cell:cell];
    cell.textLabel.textColor = RGB(51, 51, 51);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return LayoutH(50);
}

#pragma mark - setUpSwitch

- (void)setUpSwitchWithIndex:(NSInteger)index cell:(UITableViewCell *)cell {
    
    UISwitch *pushSwitch = [[UISwitch alloc] init];
    pushSwitch.onTintColor = [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"];
    pushSwitch.tag = 200 + index;
    [pushSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:pushSwitch];
    [pushSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-12);
    }];
    
    if (index == 0) {
        pushSwitch.on = self.model.sound;
    }
    else if (index == 1) {
        pushSwitch.on = self.model.shake;
    }
    else if (index == 2) {
        pushSwitch.on = self.model.dontDisturb;
    }
}

- (void)switchChanged:(UISwitch *)pushSwitch {
    
    switch (pushSwitch.tag) {
        case 200:
        {
            if (pushSwitch.on) {
                self.model.sound = 1;
                self.model.dontDisturb = 0;
            }else {
                self.model.sound = 0;
            }
            break;
        }
        case 201:
        {
            if (pushSwitch.on) {
                self.model.shake = 1;
                self.model.dontDisturb = 0;
            }else {
                self.model.shake = 0;
            }
            break;
        }
        case 202:
        {
            if (pushSwitch.on) {
                self.model.dontDisturb = 1;
                self.model.sound = 0;
                self.model.shake = 0;
            }else {
                self.model.dontDisturb = 0;
            }
            
            break;
        }
        default:
            break;
    }
    NSLog(@"%ld,%ld,%ld",(long)self.model.sound,(long)self.model.shake,self.model.dontDisturb);
    [self.mainTableView reloadData];
    NSString *url = [strTailorxAPI stringByAppendingString:updateSettings];
    weakSelf(self);
    [TXBaseNetworkRequset requestWithURL:url params:weakSelf.model.mj_keyValues success:^(id responseObject) {
        if ([responseObject[ServerResponse_success] boolValue]) {
            [weakSelf.mainTableView reloadData];
        }
    } failure:^(NSError *error) {
        [ShowMessage showMessage:error.description withCenter:self.view.center];
    } isLogin:^{
        
    }];
}

#pragma mark - lazy

- (NSArray *)listAry {
    
    if (nil == _listAry) {
        _listAry = [NSArray arrayWithObjects:@"声音", @"震动", @"勿扰模式", nil];
    }
    return _listAry;
}
@end

//
//  TXReservationSuccessController.m
//  TailorX
//
//  Created by Qian Shen on 17/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXReservationSuccessController.h"
#import "TXRechargeController.h"
#import "AppDelegate.h"
#import "TXReSuccessCell.h"
#import "TXOrdersDisplayViewController.h"
#import "AppDelegate.h"

static NSString *reSuccessCellID = @"TXReSuccessCell";


@interface TXReservationSuccessController ()<UITableViewDataSource,UITableViewDelegate>

/** 列表*/
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TXReservationSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeInterface];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - init

- (void)initializeInterface {
    self.navigationItem.title = self.model.customType ? @"预约定制" : @"预约设计师";
    self.view.backgroundColor = RGB(243, 243, 243);
    
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = leftItem;

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:RGB(46, 46, 46) forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    [rightBtn addTarget:self action:@selector(respondsToSureBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[rightItem];
}

#pragma mark - events

- (void)respondsToSureBtn {
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[AppDelegate sharedAppDelegate].tabBarVc.selectedViewController pushViewController:[TXOrdersDisplayViewController new] animated:YES];}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXReSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:reSuccessCellID forIndexPath:indexPath];
    cell.model = self.model;
    return cell;
}

#pragma mark - getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:reSuccessCellID bundle:nil] forCellReuseIdentifier:reSuccessCellID];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end


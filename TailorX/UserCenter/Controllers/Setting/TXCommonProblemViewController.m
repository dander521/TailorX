//
//  TXCommonProblemViewController.m
//  TailorX
//
//  Created by 温强 on 2017/3/23.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXCommonProblemViewController.h"

@interface TXCommonProblemViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSArray *titlesAry;
@end

@implementation TXCommonProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"常见问题";
    
    [self setUpMmainTableView];

}

#pragma mark --mainTableView

- (void)setUpMmainTableView {
    
    
    self.mainTableView = [UITableView tableWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)
                                               style:UITableViewStylePlain
                                           superView:self.view];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    
}
#pragma  mark --tableView delegate/dataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titlesAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"commonProblemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.titlesAry[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
}

#pragma mark --lazy 
- (NSArray *)titlesAry {
    
    if (_titlesAry == nil) {
        _titlesAry = [NSArray arrayWithObjects:
                      @"设计师指南",
                      @"排号交易",
                      @"是否可以退款",
                      @"收到服装",
                      @"无法预约设计师",
                      nil];
    }
    
    return _titlesAry;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

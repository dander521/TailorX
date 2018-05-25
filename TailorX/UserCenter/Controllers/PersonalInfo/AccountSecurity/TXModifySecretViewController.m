//
//  TXModifySecretViewController.m
//  TailorX
//
//  Created by RogerChen on 17/03/2017.
//  Copyright © 2017 utouu. All rights reserved.
//

#import "TXModifySecretViewController.h"
#import "TXModifySecretTableViewCell.h"

@interface TXModifySecretViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSArray <NSString *>*cellTitles;
@property (nonatomic, strong) NSArray <NSString *>*cellDetailTitles;
@property (nonatomic, strong) UITableView *modifyTableView;

@property (nonatomic, weak) UITextField *oldTextFeild;
@property (nonatomic, weak) UITextField *nowTextFeild;
@property (nonatomic, weak) UITextField *sureTextFeild;
@property (nonatomic, weak) UIButton *bottomButton;

@end

@implementation TXModifySecretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置控制器
    [self configViewController];
    // 初始化自控制器的标签(tableViewcell的内容)
    [self setUpArrays];
    // 初始化tableView
    [self setUpContentTableView];
    // 设置底部视图
    [self setupBottomButton];
    
    [_oldTextFeild becomeFirstResponder];
}

#pragma mark - Initial

/**
 配置控制器
 */
- (void)configViewController {
    self.navigationItem.title = LocalSTR(@"Str_ModifySecret");
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 * 初始化自控制器的标签(tableViewcell的内容)
 */
- (void)setUpArrays {
    self.cellTitles = @[LocalSTR(@"Str_OldSecret"), LocalSTR(@"Str_NewSecret"), LocalSTR(@"Str_ConfirmSecret")];
    self.cellDetailTitles = @[LocalSTR(@"Prompt_InputOldSecret"), LocalSTR(@"Prompt_InputNewSecret"), LocalSTR(@"Prompt_InputNewSecretAgain")];
}

/**
 * 初始化tableView
 */
- (void)setUpContentTableView {
    self.modifyTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundView = nil;
        tableView.bounces = true;
        tableView.scrollEnabled = false;
        // 适配iOS11group类型显示问题
        tableView.estimatedRowHeight = 0.0;
        tableView.estimatedSectionFooterHeight = 0.0;
        tableView.estimatedSectionHeaderHeight = 0.0;
        tableView;
    });
    [self.view addSubview:self.modifyTableView];
}

/**
 设置底部视图
 */
- (void)setupBottomButton {
    ThemeButton *bottomButton = [TailorxFactory setBlackThemeBtnWithTitle:@"确认"];
    bottomButton.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    bottomButton.titleLabel.font = FONT(17);
    [bottomButton addTarget:self action:@selector(touchModifySecret:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
//    bottomButton.enabled = NO;
//    bottomButton.alpha = 0.5;
    self.bottomButton = bottomButton;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXModifySecretTableViewCell *modifyCell = [TXModifySecretTableViewCell cellWithTableView:tableView];
    modifyCell.cellLabel.text = _cellTitles[indexPath.row];
    modifyCell.cellTextField.placeholder = _cellDetailTitles[indexPath.row];
    modifyCell.cellTextField.delegate = self;
    modifyCell.cellLineRightMargin = TXCellRightMarginType16;
    modifyCell.cellLineType = TXCellSeperateLinePositionType_Single;
    if (indexPath.row == 0) {
        self.oldTextFeild = modifyCell.cellTextField;
    }
    else if (indexPath.row == 1) {
        self.nowTextFeild = modifyCell.cellTextField;
    }
    else if (indexPath.row == 2) {
        self.sureTextFeild = modifyCell.cellTextField;
        modifyCell.cellLineType = TXCellSeperateLinePositionType_None;
    }
    

    return modifyCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

// Setup your cell margins:
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, TableViewDefaultOriginX, 0, 0)];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:false];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Custom Method

- (void)touchModifySecret:(id)sender {
    
    [self.view endEditing:YES];
    [self.modifyTableView endEditing:YES];
    
    if (![self.nowTextFeild.text isEqualToString:self.sureTextFeild.text]) {
        [ShowMessage showMessage:@"两次输入的密码不一致，请确认后重新输入" withCenter:self.view.center];
        return;
    }
    
    if (self.nowTextFeild.text.length < 6) {
        [ShowMessage showMessage:@"请输入6-18位密码" withCenter:self.view.center];
        return;
    }
    
    NSDictionary *dic = @{
                          @"oldPassword":self.oldTextFeild.text,
                          @"password":self.nowTextFeild.text,
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [TXNetRequest homeRequestMethodWithParams:dic relativeUrl:updatePassword completion:^(id responseObject, NSError *error) {
        if (error) {
            [ShowMessage showMessage:error.description withCenter:self.view.center];
            [MBProgressHUD hideHUDForView:self.view];
            return;
        }
        if (responseObject) {
            if ([responseObject[ServerResponse_success] boolValue]) {
                [TXServiceUtil logout];
                [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
            }
            [ShowMessage showMessage:responseObject[ServerResponse_msg] withCenter:self.view.center];
        }
        [MBProgressHUD hideHUDForView:self.view];
    } isLogin:^{
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toString.length > 18) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.oldTextFeild.hasText && self.nowTextFeild.hasText && self.sureTextFeild.hasText) {
//        self.bottomButton.enabled = YES;
//        self.bottomButton.alpha = 1;
    }else {
//        self.bottomButton.enabled = NO;
//        self.bottomButton.alpha = 0.5;
    }
//    NSLog(@"oldTextFeild----%@",self.oldTextFeild.text);
//    NSLog(@"nowTextFeild----%@",self.nowTextFeild.text);
//    NSLog(@"sureTextFeild----%@",self.sureTextFeild.text);
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

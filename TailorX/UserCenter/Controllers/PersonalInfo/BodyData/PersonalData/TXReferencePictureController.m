//
//  TXReferencePictureController.m
//  TailorX
//
//  Created by Qian Shen on 5/7/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXReferencePictureController.h"
#import "TXRePictureTabCell.h"
#import "TXBodyDataModel.h"
#import "NetErrorView.h"
#import "MSSBrowseModel.h"
#import "MSSBrowseLocalViewController.h"
#import "TXReplaceImageViewController.h"

#define ACTIVITYINDICATORVIEWTAG 301


static NSString *rePictureCellID = @"TXRePictureTabCell";

@interface TXReferencePictureController ()<UITableViewDataSource,NetErrorViewDelegate,TXRePictureTabCellDelegate>

/** 列表*/
@property (nonatomic, strong) UITableView *tableView;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray<TXBodyDataModel*> *dataSource;
/** 网络加载页面*/
@property (nonatomic, strong) NetErrorView *errorView;

@end

@implementation TXReferencePictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    
    [self initializeInterface];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImageSuccess) name:kNSNotificationBodyImageChangeSuccess object:nil];
}

- (void)changeImageSuccess {
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init

- (void)initializeDataSource {
    
    self.dataSource  = [@[]mutableCopy];
    
    [self loadData];
}

- (void)initializeInterface {
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.errorView];

}

#pragma mark - methods

- (void)loadData {
    
    [TXNetRequest homeRequestMethodWithParams:nil relativeUrl:strHomeFindBodyPic completion:^(id responseObject, NSError *error) {
        if (error) {
            [self.errorView stopNetViewLoadingFail:YES error:NO];
            return;
        }
        if (responseObject) {
            if ([responseObject[kSuccess] boolValue]) {
                NSLog(@"%@--",[TXBodyDataModel mj_objectArrayWithKeyValuesArray:responseObject[kData]]);
                self.dataSource = [self adjustDataSource:[TXBodyDataModel mj_objectArrayWithKeyValuesArray:responseObject[kData]]];
                
                for (NSInteger i = 0; i < self.dataSource.count; i ++) {
                    NSLog(@"%zd------ ID = %zd",self.dataSource[i].type,self.dataSource[i].ID);
                }
                [self.tableView reloadData];
                
                [self.errorView stopNetViewLoadingFail:NO error:NO];
            }else {
                [self.errorView stopNetViewLoadingFail:NO error:YES];
            }
        }
    }isLogin:^{
        [self.errorView stopNetViewLoadingFail:NO error:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

/**
 *  选择图片
 */
- (void)clickUploadImage:(NSInteger)index atView:(TXRePictureTabCell*)cell {
    __block TXBodyDataModel *model = self.dataSource[index];
    // 弹框提示替换还是删除
    weakSelf(self);
    [UIAlertController showAlertWithStyle:UIAlertControllerStyleActionSheet Title:nil message:nil actionsMsg:@[@"拍照",@"相册",@"取消"] buttonActions:^(NSInteger i) {
        if (i == 0) {
            [[CMImagePickerManager sharedCMImagePickerManager] showCameraWithViewController:weakSelf handler:^(UIImage *image) {
                model.pictureUrl = @"";
                model.image = image;
                [weakSelf.tableView reloadData];
                // 上传照片
                NSMutableDictionary *dict = [@{}mutableCopy];
                [dict setValue:@(model.ID) forKey:@"fileId"];
                [dict setValue:@(index +  1) forKey:@"type"];
                [weakSelf requsetUploadImageWithParams:dict picture:image atView:cell];
            }];
        }else if (i == 1) {
            [[CMImagePickerManager sharedCMImagePickerManager] showPhotoLibraryWithViewController:weakSelf handler:^(UIImage *image) {
                model.pictureUrl = @"";
                model.image = image;
                [weakSelf.tableView reloadData];
                // 上传照片
                NSMutableDictionary *dict = [@{}mutableCopy];
                [dict setValue:@(model.ID) forKey:@"fileId"];
                [dict setValue:@(index + 1) forKey:@"type"];
                [weakSelf requsetUploadImageWithParams:dict picture:image atView:cell];
            }];
        }
    } target:self];
}

/**
 * 上传图片或替换图片
 */

- (void)requsetUploadImageWithParams:(NSMutableDictionary*)dict picture:(UIImage *)image atView:(TXRePictureTabCell*)cell {
    __block TXBodyDataModel *model = self.dataSource[[dict[@"type"] integerValue] - 1];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    weakSelf(self);
    [TXNetRequest userCenterCommitRePictureWithParams:dict relativeUrl:strHomeAddBodyPicture pictureKey:@[@"file"] pictures:@[UIImageJPEGRepresentation(image, 0.7)] progress:^(CGFloat pro) {
   
    } completion:^(id responseObject, NSError *error) {
        if (error) {
            model.isLoadError = YES;
            [weakSelf.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [ShowMessage showMessage:kErrorTitle withCenter:kShowMessageViewFrame];
            return ;
        }
        if ([responseObject[kSuccess] boolValue]) {
            model.ID = [responseObject[kData][@"id"] integerValue];
            if (model.isLoadError) {
                model.isLoadError = NO;
                [weakSelf.tableView reloadData];
            }
        }else {
            model.isLoadError = YES;
            [weakSelf.tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [ShowMessage showMessage:responseObject[kMsg] withCenter:kShowMessageViewFrame];
    }];
}

/**
 * 删除图片
 */

- (void)requsetDeleteImageWithParams:(NSMutableDictionary*)dict ofIndex:(NSInteger)index{
    __block TXBodyDataModel *model = self.dataSource[index];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    weakSelf(self);
    [TXNetRequest homeRequestMethodWithParams:dict relativeUrl:strHomeDeleteBodyPicture completion:^(id responseObject, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [ShowMessage showMessage:error.localizedDescription withCenter:kShowMessageViewFrame];
            return ;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[kSuccess] boolValue]) {
            // 删除本地的图片
            model.pictureUrl = @"";
            model.image = nil;
            [weakSelf.tableView reloadData];
        }
        [ShowMessage showMessage:responseObject[kMsg] withCenter:kShowMessageViewFrame];
    } isLogin:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [TXServiceUtil loginViewControllerWithTarget:self.navigationController];
    }];
}

/*
 * 调整数据源
 */

- (NSMutableArray<TXBodyDataModel*>*)adjustDataSource:(NSArray<TXBodyDataModel*>*)arr {
    NSMutableArray<TXBodyDataModel*> *tempArr = [@[]mutableCopy];
    if (arr == nil || arr.count == 0) {
        for (NSInteger i = 0; i < 3; i ++) {
            TXBodyDataModel *model = [TXBodyDataModel new];
            model.type = i + 1;
            [tempArr addObject:model];
        }
        return tempArr;
    }else if (arr.count == 1) {
        if (arr.firstObject.type == 1) {
            [tempArr addObject:arr.firstObject];
            for (NSInteger i = 2; i < 4; i ++) {
                TXBodyDataModel *model = [TXBodyDataModel new];
                model.type = i;
                [tempArr addObject:model];
            }
        }else if (arr.firstObject.type == 2) {
            for (NSInteger i = 1; i < 4; i ++) {
                TXBodyDataModel *model = [TXBodyDataModel new];
                model.type = i;
                if (i == 2) {
                    [tempArr addObject:arr.firstObject];
                }else {
                    [tempArr addObject:model];
                }
            }
            
        }else if (arr.firstObject.type == 3) {
            for (NSInteger i = 1; i < 4; i ++) {
                TXBodyDataModel *model = [TXBodyDataModel new];
                model.type = i;
                if (i == 3) {
                    [tempArr addObject:arr.firstObject];
                }else {
                    [tempArr addObject:model];
                }
            }
        }
        return tempArr;
    }else if (arr.count == 2) {
        tempArr = [NSMutableArray arrayWithArray:arr];
        for (NSInteger i = 0; i < [tempArr count] - 1; i ++) {
            for (NSInteger j = i + 1; j < [tempArr count]; j ++) {
                if (tempArr[i].type > tempArr[j].type) {
                    [tempArr exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
        __block NSInteger type = 0;
        [tempArr enumerateObjectsUsingBlock:^(TXBodyDataModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            type += model.type;
        }];
        if (type == 3) {
            TXBodyDataModel *model = [TXBodyDataModel new];
            model.type = type;
            [tempArr addObject:model];
        }else if (type == 4) {
            TXBodyDataModel *model = [TXBodyDataModel new];
            model.type = 2;
            [tempArr insertObject:model atIndex:1];
        }else if (type == 5){
            TXBodyDataModel *model = [TXBodyDataModel new];
            model.type = 1;
            [tempArr insertObject:model atIndex:0];
        }
        return tempArr;
    }else if (arr.count == 3) {
        tempArr = [NSMutableArray arrayWithArray:arr];
        for (NSInteger i = 0; i < [tempArr count] - 1; i ++) {
            for (NSInteger j = i + 1; j < [tempArr count]; j ++) {
                if (tempArr[i].type > tempArr[j].type) {
                    [tempArr exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
        return tempArr;
    }
    return nil;
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXRePictureTabCell *cell = [tableView dequeueReusableCellWithIdentifier:rePictureCellID];
    if (!cell) {
         cell = [[[NSBundle mainBundle] loadNibNamed:rePictureCellID owner:self options:nil] firstObject];
    }
    cell.delegate = self;
    cell.models = self.dataSource;
    return cell;
}

#pragma mark - TXRePictureTabCellDelegate 

- (void)rePictureTabCell:(TXRePictureTabCell *)rePictureTabCell clickImgViewOfIndex:(NSInteger)index {
    TXBodyDataModel *model = self.dataSource[index];
    if (model.image) {
        // 查看大图
//        NSMutableArray *browseItemArray = [@[]mutableCopy];
//        for (TXBodyDataModel *model in self.dataSource) {
//            if (model.image) {
//                MSSBrowseModel *browseModel = [[MSSBrowseModel alloc]init];
//                browseModel.bigImage = model.image;
//                [browseItemArray addObject:browseModel];
//            }
//        }
//        MSSBrowseLocalViewController *vc = [[MSSBrowseLocalViewController alloc]initWithBrowseItemArray:browseItemArray
//                                                                                           currentIndex:index];
//        [vc showBrowseViewController:self];
        TXReplaceImageViewController *vwcImage = [[TXReplaceImageViewController alloc] initWithNibName:NSStringFromClass([TXReplaceImageViewController class]) bundle:[NSBundle mainBundle]];
        vwcImage.model = model;
        vwcImage.index = index;
        if (index == 0) {
            vwcImage.title = @"正面全身照";
        } else if (index == 1) {
            vwcImage.title = @"侧面全身照";
        } else {
            vwcImage.title = @"背面全身照";
        }
        [self.navigationController pushViewController:vwcImage animated:true];
    } else {
        // 选择照片
        [self clickUploadImage:index atView:rePictureTabCell];
    }
}

- (void)rePictureTabCell:(TXRePictureTabCell *)rePictureTabCell longClickImgViewOfIndex:(NSInteger)index {
    TXBodyDataModel *model = self.dataSource[index];
    if (!model.image) {
        return;
    } else {
        // 弹框提示替换还是删除
        weakSelf(self);
        [UIAlertController showAlertWithStyle:UIAlertControllerStyleActionSheet Title:nil message:nil actionsMsg:@[@"替换",@"删除",@"取消"] buttonActions:^(NSInteger i) {
            if (i == 1) {
                // 调用删除接口
                NSMutableDictionary *dict = [@{}mutableCopy];
                [dict setValue:@(model.ID) forKey:@"fileId"];
                [weakSelf requsetDeleteImageWithParams:dict ofIndex:index];
            }
            // 替换-去选择图片
            else if (i == 0) {
                [weakSelf clickUploadImage:index atView:rePictureTabCell];
            }
        } target:self];
    }
}

- (void)rePictureTabCell:(TXRePictureTabCell *)rePictureTabCell clickErrorImgViewOfIndex:(NSInteger)index {
    weakSelf(self);
    [UIAlertController showAlertWithStyle:UIAlertControllerStyleActionSheet Title:nil message:nil actionsMsg:@[@"重新上传",@"替换",@"取消"] buttonActions:^(NSInteger i) {
        // 重新上传
        if (i == 0) {
            TXBodyDataModel *model = self.dataSource[index];
            model.isLoadError = NO;
            [self.tableView reloadData];
            // 上传照片
            NSMutableDictionary *dict = [@{}mutableCopy];
            [dict setValue:@(model.ID) forKey:@"fileId"];
            [dict setValue:@(index + 1) forKey:@"type"];
            
            [weakSelf requsetUploadImageWithParams:dict picture:model.image atView:rePictureTabCell];
        }
        // 替换-去选择图片
        else if (i == 1) {
            [weakSelf clickUploadImage:index atView:rePictureTabCell];
        }
    } target:self];
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self.errorView showAddedTo:self.view isClearBgc:NO];
    [self loadData];
}

#pragma mark - getters

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight) style:UITableViewStylePlain];
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView setBackgroundColor:RGB(255, 255, 255)];
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NetErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
        _errorView.delegate = self;
    }
    return _errorView;
}

@end

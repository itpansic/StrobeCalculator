//
//  StrobeListCtrl.m
//  StrobeCalculator
//
//  Created by admin on 2017/8/14.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "StrobeListCtrl.h"
#import "UIView+Additions.h"
#import "commonMacroDefine.h"
#import "LJAddStrobeCtrl.h"
@interface StrobeListCtrl () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (strong, nonatomic) LJAddStrobeCtrl *ctrlAdd;
@property (copy, nonatomic) NSString *initialDataId;
@end

@implementation StrobeListCtrl

- (id)initWithDataId:(NSString *)dataId {
    if (self = [super init]) {
        self.initialDataId = dataId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(btnBackTapped)];
//    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.title = @"闪光灯选择";
    self.arrayData = [[self class] getArrayStrobe];

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self switchRightBarItemToDefault];
    // 编辑模式下是否可以选中
    self.tableView.allowsSelectionDuringEditing = NO;
    
    // 编辑模式下是否可以多选
    self.tableView.allowsMultipleSelectionDuringEditing = NO;

}

- (void)actionPop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnBackTapped {
    if (self.initialDataId && self.initialDataId.length > 0) {
        //进入列表时是已经有选择的，返回的时候需要查询这组数据最新状态并返回，如果已经删除，则返回空
        NSDictionary *dicMatch = nil;
        for (NSDictionary *dicTmp in _arrayData) {
            if (dicTmp) {
                NSString *dataId = [dicTmp objectForKey:@"dataId"];
                if ([dataId isEqualToString:self.initialDataId]) {
                    dicMatch = dicTmp;
                    break;
                }

            }

        }
        if (self.handleSelect) {
            self.handleSelect(dicMatch);
        }
    }
    [self actionPop];
    
}

- (void)switchRightBarItemToEditing {
    UIBarButtonItem *itemDone = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDoneTapped)];
    [self.navigationItem setRightBarButtonItems:@[itemDone] animated:YES];
}

- (void)switchRightBarItemToDefault {
    UIBarButtonItem *itemAdd = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddTapped)];
    UIBarButtonItem *itemEdit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(btnEditTapped)];
    [self.navigationItem setRightBarButtonItems:@[itemAdd, itemEdit] animated:YES];
}

- (void)btnDoneTapped {
    [_tableView setEditing:NO];
    [_tableView reloadData];
    [self switchRightBarItemToDefault];
}

- (void)btnAddTapped {
    LJAddStrobeCtrl *ctrl = [[LJAddStrobeCtrl alloc] init];
    self.ctrlAdd = ctrl;
    __weak typeof(self) weakself = self;
    ctrl.handleAddSuccess = ^(NSDictionary *dicStrobe) {
        if (dicStrobe) {
            [weakself.arrayData addObject:dicStrobe];
            [weakself.tableView reloadData];
            [[weakself class] updateArrayStrobe:weakself.arrayData];
        }
    };

    [ctrl show];
}

- (void)btnEditTapped {
    [_tableView setEditing:YES];
    [_tableView reloadData];
    [self switchRightBarItemToEditing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!(indexPath.row >= 0 && indexPath.row < _arrayData.count)) {
        return;
    }
    NSDictionary *dic = [_arrayData objectAtIndex:indexPath.row];
    if (!dic) {
        return;
    }
    if (self.handleSelect) {
        self.handleSelect(dic);
    }
    [self actionPop];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 首先修改model
        [_arrayData removeObjectAtIndex:indexPath.row];
        // 之后更新view
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[self class]updateArrayStrobe:self.arrayData];
        if (self.arrayData.count == 0) {
            [self btnDoneTapped];
        }
    }

}

#pragma mark 只有实现这个方法，编辑模式中才允许移动Cell
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.arrayData exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    [[self class]updateArrayStrobe:self.arrayData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!(indexPath.row >= 0 && indexPath.row < _arrayData.count)) {
        return [[UITableViewCell alloc]init];
    }
    NSDictionary *dic = [_arrayData objectAtIndex:indexPath.row];
    if (!dic) {
        return [[UITableViewCell alloc]init];
    }
    NSString *strobeName = dic[@"strobeName"];
    NSNumber *strobeGn = dic[@"gn"];
    NSString *imageName = dic[@"imageName"];
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"LJStrobeCell"];
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LJStrobeCell" owner:self options:nil] firstObject];
        cell.selectedBackgroundView = [[UIView alloc]init];
        cell.separatorInset = UIEdgeInsetsMake(0, 5, 0, 0);
    }
    UIImageView *iv =  (UIImageView *)[cell viewWithTag:101];
    
    UILabel *lbTitle = (UILabel *)[cell viewWithTag:111];
    UILabel *lbSubTitle = (UILabel *)[cell viewWithTag:112];
    SSButton *btnEdit = (SSButton *)[cell viewWithTag:121];
    btnEdit.param1 = indexPath;
    btnEdit.param2 = dic;
    btnEdit.hidden = self.tableView.isEditing;
    [btnEdit addTarget:self action:@selector(btnStrobeEditTapped:) forControlEvents:UIControlEventTouchUpInside];
    lbTitle.text = strobeName;
    lbSubTitle.text = [NSString stringWithFormat:@"GN值(ISO100 米): %ld",[strobeGn integerValue]];
    iv.hidden = YES;
    iv.image = [[self class]imageWithImageName:imageName];
    iv.hidden = iv.image ? NO : YES;
    if (!iv.hidden) {
        lbTitle.left = iv.right + 5;
        lbSubTitle.left = iv.right + 5;
    }
    else {
        lbTitle.left = 5;
        lbSubTitle.left = 5;
    }
    float fRight = SCREEN_WIDTH - 30;
    lbTitle.width = fRight - lbTitle.left;
    lbSubTitle.width = fRight - lbSubTitle.left;
    return cell;
}

+ (NSMutableArray *)getArrayStrobe {
    NSString *path = [[self class] cachePath];
    path = [path stringByAppendingPathComponent:@"strobeList.plist"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:path];
    if (!array) {
        array = [NSMutableArray array];
    }
    return array;
}

+ (void)updateArrayStrobe:(NSMutableArray *)array {
    NSString *path = [[self class] cachePath];
    path = [path stringByAppendingPathComponent:@"strobeList.plist"];
    
    if (![array writeToFile:path atomically:YES]) {
        
    }
}

//获取当前版本的缓存目录
+ (NSString *)cachePath {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if (!paths || paths.count == 0) {
        return nil;
    }
    NSString *cachePath = [paths objectAtIndex:0];
    cachePath = [cachePath stringByAppendingPathComponent:@"/AppData/"];
    if (![fileMgr fileExistsAtPath:cachePath]) {
        if (![fileMgr createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil])
            return nil;
    }
    return cachePath;
}

//获取图片缓存目录
+ (NSString *)imageCachePath {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *cachePath = [[self class] cachePath];
    cachePath = [cachePath stringByAppendingPathComponent:@"/Image/"];
    if (![fileMgr fileExistsAtPath:cachePath]) {
        if (![fileMgr createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil])
            return nil;
    }
    return cachePath;
}

//获取图片地址
+ (UIImage *)imageWithImageName:(NSString *)imageName {
    if (imageName && imageName.length > 0) {
        NSString *imageCachePath = [[self class] imageCachePath];
        NSString *imagePath = [imageCachePath stringByAppendingPathComponent:imageName];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if ([fileMgr fileExistsAtPath:imagePath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            if (image) {
                return image;
            }
        }
    }
    return nil;
}

- (void)btnStrobeEditTapped:(SSButton *)btn {
    NSIndexPath *indexPath = (NSIndexPath *)btn.param1;
    NSDictionary *dic = (NSDictionary *)btn.param2;
    if (indexPath && [indexPath isKindOfClass:[NSIndexPath class]] &&
        dic && [dic isKindOfClass:[NSDictionary class]]) {
        self.ctrlAdd = [[LJAddStrobeCtrl alloc]initWithDictionary:dic];
        __weak typeof(self) weakself = self;
        self.ctrlAdd.handleEditSuccess = ^(NSDictionary *dicStrobe) {
            if (dicStrobe) {
                NSString *dataId = dicStrobe[@"dataId"];
                if (dataId && dataId.length > 0) {
                    NSDictionary *dicTarget = nil;
                    NSInteger i = 0;
                    for (NSDictionary *dicTmp in weakself.arrayData) {
                        if ([dicTmp[@"dataId"] isEqualToString:dataId]) {
                            dicTarget = dicTmp;
                            break;
                        }
                        i++;
                    }
                    if (dicTarget) {
                        [weakself.arrayData replaceObjectAtIndex:i withObject:dicStrobe];
                        [weakself.tableView reloadData];
                        [[weakself class] updateArrayStrobe:weakself.arrayData];
                    }

                }

            }
        };
        [self.ctrlAdd show];
    }
}
@end

//
//  LJAddStrobeCtrl.h
//  BeautyPlus
//
//  Created by peter on 15/3/24.
//  Copyright (c) 2015年 BeautyPlus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJAddStrobeCtrl : UIViewController

- (void)show;

- (id)initWithDictionary:(NSDictionary *)dic;

//添加闪光灯成功handle
@property (copy, readwrite, nonatomic) void (^handleAddSuccess)(NSDictionary *dicStrobe);
@property (copy, readwrite, nonatomic) void (^handleEditSuccess)(NSDictionary *dicStrobe);


@end

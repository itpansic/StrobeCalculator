//
//  StrobeListCtrl.h
//  StrobeCalculator
//
//  Created by admin on 2017/8/14.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StrobeListCtrl : UIViewController

- (id)initWithDataId:(NSString *)dataId;

+ (NSMutableArray *)getArrayStrobe;

+ (void)updateArrayStrobe:(NSMutableArray *)array;
//获取当前版本的缓存目录
+ (NSString *)cachePath;

//获取图片缓存目录
+ (NSString *)imageCachePath;

//获取图片
+ (UIImage *)imageWithImageName:(NSString *)imageName;

@property (copy, readwrite, nonatomic) void (^handleSelect)(NSDictionary *dicStrobe);
@end

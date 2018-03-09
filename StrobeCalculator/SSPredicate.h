//
//  SSPredicate.h
//  uhuibao
//
//  Created by Peter Liu on 13-9-30.
//  Copyright (c) 2013年 Peter Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

//正则表达式比较类
@interface SSPredicate : NSObject {
@private
    
}
//消费密码字符串，至少有一位
+ (BOOL)fitToConsumePasswordLeastOne:(NSString *)aString;
//消费密码字符串，可为0位
+ (BOOL)fitToConsumePassword:(NSString *)aString;

//由字母和数字组成的字符串，可全为字母或数字，至少有一位
+ (BOOL)fitToCharacterOrNumber:(NSString *)aString;
//由字母和数字组成的字符串，可全为字母或数字，可为零位
+ (BOOL)fitToCharacterOrNumberLeastOne:(NSString *)aString;
+ (BOOL)fitToPriceString:(NSString *)aString;
+ (BOOL)fitTo8Numbers:(NSString *)aString;
+ (BOOL)fitTo09Numbers:(NSString *)aString;
+ (BOOL)fitTo16Numbers:(NSString *)aString;
+ (BOOL)fitToDateFormat1:(NSString *)aString;
+ (BOOL)fitToChinaUnicomPhoneNumberWithString:(NSString*)aString;
+ (BOOL)fitToChineseIDWithString:(NSString*)aString;
+ (BOOL)fitToEmailWithString:(NSString*)aString;
+ (BOOL)fitToMobileNumberWithString:(NSString*)aString;
+ (BOOL)ifIsMobileNumberWithString:(NSString*)aString;
+ (BOOL)fitWithString:(NSString*)aString countBetween:(NSInteger)leastCount to:(NSInteger)mostCount;
+ (BOOL)fitToNickNameFormatWithString:(NSString *)aString;
//+ (BOOL)fitToAllNumberWithString:(NSString*)aString;
//+ (BOOL)fitToAllNumberWithString:(NSString*)aString countBetween:(NSInteger)leastCount to:(NSInteger)mostCount;
+ (NSString *)getNumberStringFromString:(NSString *)str;
+ (BOOL)fitToHanderString:(NSString *)aString;
+ (BOOL)fitToChineseFormatWithString:(NSString *)aString;
+ (BOOL)fitToVersionCode:(NSString *)aString;
@end

//
//  SSPredicate.m
//  uhuibao
//
//  Created by Peter Liu on 13-9-30.
//  Copyright (c) 2013年 Peter Liu. All rights reserved.
//

#import "SSPredicate.h"

//////////////////////////////////////////////


@implementation SSPredicate

+ (BOOL)fitToConsumePasswordLeastOne:(NSString *)aString {
    
    NSString *regex = @"^[1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\\`\\~\\!\\@\\#\\$\\%\\^\\&\\*\\(\\)\\_\\+\\-\\=\\[\\]\\;\\'\\,\\.\\/\\{\\}\\:\\|\\\"\\<\\>\\?]+$";
    NSPredicate* pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:aString];
}

+ (BOOL)fitToConsumePassword:(NSString *)aString {
    
    NSString *regex = @"^[1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\\`\\~\\!\\@\\#\\$\\%\\^\\&\\*\\(\\)\\_\\+\\-\\=\\[\\]\\;\\'\\,\\.\\/\\{\\}\\:\\|\\\"\\<\\>\\?]*$";
    NSPredicate* pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:aString];
}

+ (BOOL)fitToCharacterOrNumber:(NSString *)aString {
    NSString *regex = @"^[0-9a-zA-Z]*?$";
    NSPredicate* pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:aString];
}

+ (BOOL)fitToCharacterOrNumberLeastOne:(NSString *)aString {
    NSString *regex = @"^[0-9a-zA-Z]+?$";
    NSPredicate* pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:aString];
}


+ (BOOL)fitToPriceString:(NSString *)aString {
    NSString *regex = @"^(([1-9]\\d{0,9})|0)(\\.\\d{0,2})?$";
    NSPredicate* pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:aString];
}

+ (BOOL)fitToHanderString:(NSString *)aString {
    NSString *regex = @"^(([1-9]\\d{0,7})|0)(\\.\\d{0,2})?$";
    NSPredicate* pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:aString];
}
+ (NSString *)getNumberStringFromString:(NSString *)str {
    if (!str) return nil;
    NSString *strNum=@"";
    long dateLength = [str length];
    long i = 0;
    NSString *character;

    for (i=0; i<dateLength; ++i) {
        
        character=[str substringWithRange:NSMakeRange(i, 1)];//循环取每个字符
        
        if ([character isEqual: @"0"]|
            [character isEqual: @"1"]|
            [character isEqual: @"2"]|
            [character isEqual: @"3"]|
            [character isEqual: @"4"]|
            [character isEqual: @"5"]|
            [character isEqual: @"6"]|
            [character isEqual: @"7"]|
            [character isEqual: @"8"]|
            [character isEqual: @"9"]) {
            
            strNum = [strNum stringByAppendingString:character];//是数字的累加起来
        }
        
    }
    return strNum;
}

//
+ (BOOL)fitToEmailWithString:(NSString*)aString
{
    NSString *regex = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    NSPredicate* pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:aString];
}

+ (BOOL)fitWithString:(NSString*)aString countBetween:(NSInteger)leastCount to:(NSInteger)mostCount
{
    if (leastCount > 0 && mostCount > 0 && mostCount > leastCount) {
        NSString *regex = [NSString stringWithFormat:@"(^.{%ld,%ld}$)",leastCount,mostCount];
        NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [pred evaluateWithObject:aString];
    }
    return NO;
}

+ (BOOL)fitToNickNameFormatWithString:(NSString *)aString {
   // NSString *regex = @"[\\u4e00-\\u9fa5_0-9a-zA-Z]{2,10}";
     NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5]+";
    
    NSPredicate* pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:aString];
    
}

+ (BOOL)fitToChineseFormatWithString:(NSString *)aString
{
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:aString];
}

+ (BOOL)fitToMobileNumberWithString:(NSString*)aString
{
    NSString *strMobile = [SSPredicate getNumberStringFromString:aString];
    NSString * regex = @"1[0-9][0,1,2,3,4,5,6,7,8,9][0-9]{8}";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:strMobile];
}

+ (BOOL)ifIsMobileNumberWithString:(NSString*)aString
{
    NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-9]|7[0678]|8[0-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    BOOL res1 = [regextestmobile evaluateWithObject:aString];
    BOOL res2 = [regextestcm evaluateWithObject:aString];
    BOOL res3 = [regextestcu evaluateWithObject:aString];
    BOOL res4 = [regextestct evaluateWithObject:aString];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)fitToChineseIDWithString:(NSString*)aString
{
    
    NSString * regex1 = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
    NSString * regex2 = @"^[1-9]\\d{5}(19|20)\\d{2}(0\\d|1[0-2])(([0|1|2]\\d)|3[0-1])\\d{3}(x|X|\\d)$";
    //NSString * regex2 = @"^[1-9]\\d{16}(x|X|\\d)$";
    //NSString * regex2 = @"^\\d{18}$";
    NSPredicate* pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    NSPredicate* pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    if ([pred1 evaluateWithObject:aString]) {
        //15位身份证号码
        NSString *strTmp;
        NSRange rg;
        //获得省代码
        rg.length = 2;
        rg.location = 0;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 41 || [strTmp intValue] < 11) {
            //省代码不合法
            return NO;
        }
        //获得月份
        rg.location = 8;
        rg.length = 2;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 12 || [strTmp intValue] < 1) {
            //月份不合法
            return NO;
        }
        
        //获得日
        rg.location = 10;
        rg.length = 2;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 31 || [strTmp intValue] < 1) {
            //日不合法
            return NO;
        }
        
        return YES;
    }
    else if ([pred2 evaluateWithObject:aString])
    {
        //18位身份证号码
        NSString *strTmp;
        NSRange rg;
        //获得省代码
        rg.length = 2;
        rg.location = 0;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 99 || [strTmp intValue] < 1) {
            //省代码不合法
            return NO;
        }
        //获得年
        rg.location = 6;
        rg.length = 4;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 2100 || [strTmp intValue] < 1900) {
            //年不合法
            return NO;
        }
        //获得月份
        rg.location = 10;
        rg.length = 2;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 12 || [strTmp intValue] < 1) {
            //月份不合法
            return NO;
        }
        
        //获得日
        rg.location = 12;
        rg.length = 2;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 31 || [strTmp intValue] < 1) {
            //日不合法
            return NO;
        }
        
        NSRange rangeLast;
        rangeLast.length = 1;
        rangeLast.location = 17;
        NSString *strLast = [aString substringWithRange:rangeLast];
        if ([strLast isEqualToString:@"x"]) {
            strLast = @"X";
        }
        
        
        int i = 0;
        int sum = 0;
        int a[17] = {7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
        
        for (i = 0; i < 17; i++) {
            NSRange range;
            range.location = i;
            range.length = 1;
            int intValue = [[aString substringWithRange:range]intValue];
            if (intValue >= 0 && intValue <=9) {
                sum += intValue * a[i];
            }
            else
            {
                //非数字
                return NO;
            }
        }
        int y = sum % 11;
        
        NSDictionary* dicTmp = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"1",@"0",
                                @"0",@"1",
                                @"X",@"2",
                                @"9",@"3",
                                @"8",@"4",
                                @"7",@"5",
                                @"6",@"6",
                                @"5",@"7",
                                @"4",@"8",
                                @"3",@"9",
                                @"2",@"10", nil];
        NSString *strCounted = [dicTmp objectForKey:[NSString stringWithFormat:@"%d",y]];
        if ([strLast isEqualToString:strCounted]) {
            return YES;
        }
        else
            return NO;//验证码不匹配
        
    }
    else
    {
        return NO;
    }
}

+ (BOOL)fitToChinaUnicomPhoneNumberWithString:(NSString*)aString
{
    NSString * regex = @"^1(3[0-2]|5[56]|8[56])\\d{8}$";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:aString];
}

+ (BOOL)fitToDateFormat1:(NSString *)aString {
    NSString * regex = @"(19|20)\\d{2}-\\d{1,2}-\\d{1,2} ((((0|1)\\d)|(2[0-4]))|\\d):(([0-5]\\d)|\\d):(([0-5]\\d)|\\d)";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:aString];
}

+ (BOOL)fitTo09Numbers:(NSString *)aString {
    NSString * regex = @"\\d{0,9}";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:aString];
}

+ (BOOL)fitTo16Numbers:(NSString *)aString {
    NSString * regex = @"\\d{1,6}";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:aString];
}

+ (BOOL)fitTo8Numbers:(NSString *)aString {
    NSString * regex = @"\\d{8}";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:aString];
}

+ (BOOL)fitToVersionCode:(NSString *)aString
{
    NSString *regex = @"^(\\d+\\.){1,}\\d$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:aString];
}


@end

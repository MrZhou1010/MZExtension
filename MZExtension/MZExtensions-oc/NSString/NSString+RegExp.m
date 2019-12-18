//
//  NSString+RegExp.m
//  MZExtension
//
//  Created by Mr.Z on 2019/12/18.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

#import "NSString+RegExp.h"

@implementation NSString (RegExp)

/// 根据正则条件校验字符串
- (BOOL)verifyWithCondition:(NSString *)condition {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", condition];
    return [predicate evaluateWithObject:self];
}

/// 判断是否为数字
- (BOOL)isNumber {
    NSString *condition = @"^[0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", condition];
    return [predicate evaluateWithObject:self];
}

/// 判断是否为26个英文字母组成的字符串
- (BOOL)isLetter {
    NSString *condition = @"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", condition];
    return [predicate evaluateWithObject:self];
}

/// 判断是否为数字和26个英文字母组成的字符串
- (BOOL)isHaveSpecialCharacter {
    NSString *condition = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", condition];
    return [predicate evaluateWithObject:self];
}

/// 判断是否为汉字
- (BOOL)isChinese {
    NSString *condition = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", condition];
    return [predicate evaluateWithObject:self];
}

/// 手机号码验证
- (BOOL)isMobileNumber {
    if (self.length != 11) {
        return NO;
    }
    NSString *condition = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", condition];
    return [predicate evaluateWithObject:self];
}

/// 身份证号验证（15位或18位数字）
- (BOOL)isCardID {
    if (self.length != 15 && self.length != 18) {
        return NO;
    }
    NSString *condition = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *cardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", condition];
    return [cardPredicate evaluateWithObject:self];
}

/// 密码验证
- (BOOL)isPassword {
    NSString *condition =@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *prediction = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", condition];
    return [prediction evaluateWithObject:self];
}

/// 车牌号验证
- (BOOL)isPlateNumber {
    NSString *condition = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *prediction = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", condition];
    return [prediction evaluateWithObject:self];
}

/// 邮箱地址验证
- (BOOL)isEmail {
    NSString *condition = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *prediction = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", condition];
    return [prediction evaluateWithObject:self];
}

/// 是否包含有空格
- (BOOL)isHaveSpace {
    NSRange range = [self rangeOfString:@" "];
    return range.location == NSNotFound ? NO : YES;
}

/// 非空字符判断
- (BOOL)isEmptyString {
    if (!self || [self isEqualToString:@""] || [self isEqualToString:@"null"] || [self isEqualToString:@"(null)"] || [self isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}

@end

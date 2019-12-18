//
//  NSString+RegExp.h
//  MZExtension
//
//  Created by Mr.Z on 2019/12/18.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (RegExp)

/// 根据正则条件校验字符串
- (BOOL)verifyWithCondition:(NSString *)condition;

/// 判断是否为数字
- (BOOL)isNumber;

/// 判断是否为26个英文字母组成的字符串
- (BOOL)isLetter;

/// 判断是否为数字和26个英文字母组成的字符串
- (BOOL)isHaveSpecialCharacter;

/// 判断是否为汉字
- (BOOL)isChinese;

/// 手机号码验证
- (BOOL)isMobileNumber;

/// 身份证号验证（15位或18位数字）
- (BOOL)isCardID;

/// 密码验证
- (BOOL)isPassword;

/// 车牌号验证
- (BOOL)isPlateNumber;

/// 邮箱地址验证
- (BOOL)isEmail;

/// 是否包含有空格
- (BOOL)isHaveSpace;

/// 非空字符判断
- (BOOL)isEmptyString;

@end

NS_ASSUME_NONNULL_END

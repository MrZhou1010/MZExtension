//
//  NSString+AES.m
//  MZExtension
//
//  Created by Mr.Z on 2019/12/16.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

#import "NSString+AES.h"
#import <CommonCrypto/CommonCrypto.h>

/// 初始向量值(Initialization Vector)
static NSString * const kIv128 = @"0102030405060708";
static NSString * const kIv256 = @"01020304050607080102030405060708";

@implementation NSString (AES)

- (NSString *)aesEncryptWithKey:(NSString *)key type:(AESCryptoType)type {
    const char *cStr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    NSData *result = [[self class] aesEncryptWithData:data key:key type:type];
    if (result && result.length > 0) {
        Byte *tempData = (Byte *)[result bytes];
        NSMutableString *outPutStr = [NSMutableString stringWithCapacity:result.length];
        for (int i = 0; i < result.length; i++) {
            [outPutStr appendFormat:@"%02x", tempData[i]];
        }
        return outPutStr.copy;
    }
    return nil;
}

- (NSString *)aesDecryptWithKey:(NSString *)key type:(AESCryptoType)type {
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2.0];
    unsigned char whole_bytes;
    char byte_chars[3] = {'\0', '\0', '\0'};
    for (int i = 0; i < self.length / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i * 2];
        byte_chars[1] = [self characterAtIndex:i * 2 + 1];
        whole_bytes = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_bytes length:1];
    }
    NSData *result = [[self class] aesDecryptWithData:data key:key type:type];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+ (NSData *)aesEncryptWithData:(NSData *)data key:(NSString *)key type:(AESCryptoType)type {
    NSData *result = nil;
    switch (type) {
        case AESCryptoType128:
            result = [[self class] aes128CryptWithData:data key:key mode:kCCEncrypt iv:kIv128];
            break;
        case AESCryptoType256:
            result = [[self class] aes256CryptWithData:data key:key mode:kCCEncrypt iv:kIv256];
            break;
        default:
            break;
    }
    return result;
}

+ (NSData *)aesDecryptWithData:(NSData *)data key:(NSString *)key type:(AESCryptoType)type {
    NSData *result = nil;
    switch (type) {
        case AESCryptoType128:
            result = [[self class] aes128CryptWithData:data key:key mode:kCCDecrypt iv:kIv128];
            break;
        case AESCryptoType256:
            result = [[self class] aes256CryptWithData:data key:key mode:kCCDecrypt iv:kIv256];
            break;
        default:
            break;
    }
    return result;
}

+ (NSData *)aes128CryptWithData:(NSData *)data key:(NSString *)key mode:(CCOperation)operation iv:(NSString *)iv {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = data.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus;
    // 如果没有初始向量值,则使用ECB模式,否使用CBC模式
    if (!iv || [iv isEqualToString:@""]) {
        cryptStatus = CCCrypt(operation, kCCAlgorithmAES, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCKeySizeAES128, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesCrypted);
    } else {
        char ivPtr[kCCBlockSizeAES128 + 1];
        memset(ivPtr, 0, sizeof(ivPtr));
        [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
        cryptStatus = CCCrypt(operation, kCCAlgorithmAES, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES128, ivPtr, [data bytes], dataLength, buffer, bufferSize, &numBytesCrypted);
    }
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
    }
    free(buffer);
    return nil;
}

+ (NSData *)aes256CryptWithData:(NSData *)data key:(NSString *)key mode:(CCOperation)operation iv:(NSString *)iv {
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = data.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus;
    // 如果没有初始向量值,则使用ECB模式,否使用CBC模式
    if (!iv || [iv isEqualToString:@""]) {
        cryptStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCKeySizeAES256, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesCrypted);
    } else {
        char ivPtr[kCCKeySizeAES256 + 1];
        memset(ivPtr, 0, sizeof(ivPtr));
        [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
        cryptStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCKeySizeAES256, ivPtr, [data bytes], dataLength, buffer, bufferSize, &numBytesCrypted);
    }
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
    }
    free(buffer);
    return nil;
}

@end

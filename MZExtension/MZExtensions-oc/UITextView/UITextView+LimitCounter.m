//
//  UITextView+LimitCounter.m
//  MZExtension
//
//  Created by 木木 on 2019/12/13.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

#import "UITextView+LimitCounter.h"
#import <objc/runtime.h>

static char limitCountKey;
static char labMarginKey;
static char labHeightKey;

@implementation UITextView (LimitCounter)

+ (void)load {
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
                                   class_getInstanceMethod(self.class, @selector(limitCounter_swizzling_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(limitCounter_swizzled_dealloc)));
}

#pragma mark - swizzled
- (void)limitCounter_swizzled_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
        [self removeObserver:self forKeyPath:@"layer.borderWidth"];
        [self removeObserver:self forKeyPath:@"text"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    [self limitCounter_swizzled_dealloc];
}

- (void)limitCounter_swizzling_layoutSubviews {
    [self limitCounter_swizzling_layoutSubviews];
    if (self.limitCount) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        textContainerInset.bottom = self.labHeight;
        self.contentInset = textContainerInset;
        CGFloat x = CGRectGetMinX(self.frame) + self.layer.borderWidth;
        CGFloat y = CGRectGetMaxY(self.frame) - self.contentInset.bottom - self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds) - self.layer.borderWidth * 2;
        CGFloat height = self.labHeight;
        self.inputLimitLabel.frame = CGRectMake(x, y, width, height);
        if ([self.superview.subviews containsObject:self.inputLimitLabel]) {
            return;
        }
        [self.superview insertSubview:self.inputLimitLabel aboveSubview:self];
    }
}

#pragma mark - associated
- (NSInteger)limitCount {
    return [objc_getAssociatedObject(self, &limitCountKey) integerValue];
}

- (void)setLimitCount:(NSInteger)limitCount {
    objc_setAssociatedObject(self, &limitCountKey, @(limitCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLimitCount];
}

- (CGFloat)labMargin {
    return [objc_getAssociatedObject(self, &labMarginKey) floatValue];
}

- (void)setLabMargin:(CGFloat)labMargin {
    objc_setAssociatedObject(self, &labMarginKey, @(labMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLimitCount];
}

- (CGFloat)labHeight {
    return [objc_getAssociatedObject(self, &labHeightKey) floatValue];
}

- (void)setLabHeight:(CGFloat)labHeight {
    objc_setAssociatedObject(self, &labHeightKey, @(labHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLimitCount];
}

#pragma mark - config
- (void)configTextView {
    self.labMargin = 10;
    self.labHeight = 20;
}

#pragma mark - update
- (void)updateLimitCount {
    if (self.text.length > self.limitCount) {
        UITextRange *markedRange = [self markedTextRange];
        if (markedRange) {
            return;
        }
        NSRange range = [self.text rangeOfComposedCharacterSequenceAtIndex:self.limitCount];
        self.text = [self.text substringToIndex:range.location];
    }
    NSString *showText = [NSString stringWithFormat:@"%lu/%ld", (unsigned long)self.text.length, (long)self.limitCount];
    self.inputLimitLabel.text = showText;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:showText];
    NSUInteger length = [showText length];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    // 设置与尾部的距离
    style.tailIndent = -self.labMargin;
    // 靠右显示
    style.alignment = NSTextAlignmentRight;
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    self.inputLimitLabel.attributedText = attrString;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"layer.borderWidth"] || [keyPath isEqualToString:@"text"]) {
        [self updateLimitCount];
    }
}

#pragma mark - lazy
- (UILabel *)inputLimitLabel {
    UILabel *label = objc_getAssociatedObject(self, @selector(inputLimitLabel));
    if (!label) {
        label = [[UILabel alloc] init];
        label.backgroundColor = self.backgroundColor;
        label.textColor = [UIColor lightGrayColor];
        label.font = self.font;
        label.textAlignment = NSTextAlignmentRight;
        objc_setAssociatedObject(self, @selector(inputLimitLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLimitCount) name:UITextViewTextDidChangeNotification object:self];
        [self addObserver:self forKeyPath:@"layer.borderWidth" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        [self configTextView];
    }
    return label;
}

@end

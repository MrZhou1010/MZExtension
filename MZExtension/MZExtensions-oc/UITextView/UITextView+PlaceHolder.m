//
//  UITextView+PlaceHolder.m
//  MZExtension
//
//  Created by Mr.Z on 2019/12/13.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

#import "UITextView+PlaceHolder.h"
#import <objc/runtime.h>

static const void *mz_placeHolderKey;

@interface UITextView ()

@property (nonatomic, readonly) UILabel *mz_placeHolderLabel;

@end

@implementation UITextView (PlaceHolder)

+ (void)load {
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
                                   class_getInstanceMethod(self.class, @selector(mzPlaceHolder_swizzling_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(mzPlaceHolder_swizzled_dealloc)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"setText:")),
                                   class_getInstanceMethod(self.class, @selector(mzPlaceHolder_swizzled_setText:)));
}

#pragma mark - swizzled
- (void)mzPlaceHolder_swizzled_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self mzPlaceHolder_swizzled_dealloc];
}

- (void)mzPlaceHolder_swizzling_layoutSubviews {
    if (self.mz_placeHolder) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
        CGFloat x = lineFragmentPadding + textContainerInset.left + self.layer.borderWidth;
        CGFloat y = textContainerInset.top + self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds) - x - textContainerInset.right - 2.0 * self.layer.borderWidth;
        CGFloat height = [self.mz_placeHolderLabel sizeThatFits:CGSizeMake(width, 0)].height;
        self.mz_placeHolderLabel.frame = CGRectMake(x, y, width, height);
    }
    [self mzPlaceHolder_swizzling_layoutSubviews];
}

- (void)mzPlaceHolder_swizzled_setText:(NSString *)text {
    [self mzPlaceHolder_swizzled_setText:text];
    if (self.mz_placeHolder) {
        [self updatePlaceHolder];
    }
}

#pragma mark - associated
- (NSString *)mz_placeHolder {
    return objc_getAssociatedObject(self, &mz_placeHolderKey);
}

- (void)setMz_placeHolder:(NSString *)mz_placeHolder {
    objc_setAssociatedObject(self, &mz_placeHolderKey, mz_placeHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updatePlaceHolder];
}

- (UIColor *)mz_placeHolderColor {
    return self.mz_placeHolderLabel.textColor;
}

- (void)setMz_placeHolderColor:(UIColor *)mz_placeHolderColor {
    self.mz_placeHolderLabel.textColor = mz_placeHolderColor;
}

- (NSString *)placeholder {
    return self.mz_placeHolder;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.mz_placeHolder = placeholder;
}

#pragma mark - update
- (void)updatePlaceHolder {
    if (self.text.length) {
        [self.mz_placeHolderLabel removeFromSuperview];
        return;
    }
    self.mz_placeHolderLabel.font = self.font?self.font:self.cacutDefaultFont;
    self.mz_placeHolderLabel.textAlignment = self.textAlignment;
    self.mz_placeHolderLabel.text = self.mz_placeHolder;
    [self insertSubview:self.mz_placeHolderLabel atIndex:0];
}

#pragma mark - lazy
- (UILabel *)mz_placeHolderLabel {
    UILabel *placeHolderLab = objc_getAssociatedObject(self, @selector(mz_placeHolderLabel));
    if (!placeHolderLab) {
        placeHolderLab = [[UILabel alloc] init];
        placeHolderLab.numberOfLines = 0;
        placeHolderLab.textColor = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, @selector(mz_placeHolderLabel), placeHolderLab, OBJC_ASSOCIATION_RETAIN);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaceHolder) name:UITextViewTextDidChangeNotification object:self];
    }
    return placeHolderLab;
}

- (UIFont *)cacutDefaultFont {
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextView *textview = [[UITextView alloc] init];
        textview.text = @" ";
        font = textview.font;
    });
    return font;
}

@end

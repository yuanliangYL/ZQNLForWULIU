//
//  UITextView+WLPlaceHolder.h
//  ZWYD
//
//  Created by pro on 16/9/14.
//  Copyright © 2016年 WLW. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double UITextView_PlaceholderVersionNumber;
FOUNDATION_EXPORT const unsigned char UITextView_PlaceholderVersionString[];

@interface UITextView (WLPlaceHolder)

///* placeHolder */
//@property (nonatomic, retain) NSString *placeholder;
//
////placeHolder Color
//@property (nonatomic, retain) UIColor *placeholderColor;

@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) IBInspectable  UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;


@end

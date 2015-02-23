// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#if !TARGET_IPHONE
#import <AppKit/AppKit.h>
#else
#import <UIKit/UIKit.h>
#endif

@interface NSLayoutConstraint (QK)

+ (void)activateAndCatchConstraints:(NSArray*)constraints;

+ (NSArray *)constraintsAndCatchWithVisualFormat:(NSString *)format
                                         options:(NSLayoutFormatOptions)options
                                         metrics:(NSDictionary *)metrics
                                           views:(NSDictionary *)views;

@end

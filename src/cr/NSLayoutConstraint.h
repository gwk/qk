// © 2014 George King. Permission to use this file is granted in license-qk.txt.

#import "TargetConditionals.h" 
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

@interface NSLayoutConstraint (QK)

+ (void)activateAndCatchConstraints:(NSArray*)constraints;

+ (NSArray *)constraintsAndCatchWithVisualFormat:(NSString *)format
                                         options:(NSLayoutFormatOptions)options
                                         metrics:(NSDictionary *)metrics
                                           views:(NSDictionary *)views;

@end

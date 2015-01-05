// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#import <UIKit/UIKit.h>


@interface NSLayoutConstraint (QK)

+ (void)activateAndCatchConstraints:(NSArray*)constraints;

+ (NSArray *)constraintsAndCatchWithVisualFormat:(NSString *)format
                                         options:(NSLayoutFormatOptions)options
                                         metrics:(NSDictionary *)metrics
                                           views:(NSDictionary *)views;

@end

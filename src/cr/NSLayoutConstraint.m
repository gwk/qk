// © 2014 George King.
// Permission to use this file is granted in license-qk.txt.

#import "NSLayoutConstraint.h"


@implementation NSLayoutConstraint (QK)


+ (void)activateAndCatchConstraints:(NSArray*)constraints {
  @try {
    [self activateConstraints:constraints];
  }
  @catch (NSException* e) {
    NSLog(@"ERROR: NSLayoutConstraint +activateConstraints failed: %@\nexception: %@", constraints, e);
    [e raise]; // TODO: desirable?
  }
}


+ (NSArray *)constraintsAndCatchWithVisualFormat:(NSString *)format
                                         options:(NSLayoutFormatOptions)options
                                         metrics:(NSDictionary *)metrics
                                           views:(NSDictionary *)views {
  @try {
    return [self constraintsWithVisualFormat:format options:options metrics:metrics views:views];
  }
  @catch (NSException* e) {
    NSLog(@"ERROR: NSLayoutConstraints constraintWithVisualFormat failed:\n%@\nexception: %@", format, e);
    return @[];
  }
}


@end

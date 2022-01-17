//
//  ProgressView.h
//  AirTickets
//
//  Created by Daniil Kniss on 10.07.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressView : UIView

+ (instancetype)sharedInstance;

- (void)show:(void (^)(void))completion;
- (void)dismiss:(void (^)(void))complition;

@end

NS_ASSUME_NONNULL_END

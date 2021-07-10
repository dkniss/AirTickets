//
//  ProgressView.m
//  AirTickets
//
//  Created by Daniil Kniss on 10.07.2021.
//

#import "ProgressView.h"

@interface ProgressView ()
@end

@implementation ProgressView {
    BOOL isActive;
}

+ (instancetype)sharedInstance {
    static ProgressView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIWindow * currentwindow = [[UIApplication sharedApplication] keyWindow];
        instance = [[ProgressView alloc] initWithFrame: currentwindow.bounds];
        [instance setup];
    });
    return instance;
}

- (void)setup {
    self.backgroundColor = [UIColor systemBlueColor];
    [self createPlanes];
}

- (void)createPlanes {
    for (int i = 1; i < 6; i++) {
        UIImageView *plane = [[UIImageView alloc] initWithFrame:CGRectMake(-50.0, ((float)i * 100.0) + 150.0, 50.0, 50.0)];
        plane.tag = i;
        plane.image = [UIImage imageNamed:@"plane"];
        [self addSubview:plane];
    }
}

- (void)startAnimating:(NSInteger)planeId {
    if (!isActive) return;
    if (planeId >= 6) planeId = 1;

    UIImageView *plane = [self viewWithTag:planeId];
    if (plane) {
        [UIView animateWithDuration:1.0 animations:^{
            plane.frame = CGRectMake(self.bounds.size.width, plane.frame.origin.y, 50.0, 50.0);
        } completion:^(BOOL finished) {
            plane.frame = CGRectMake(-50.0, plane.frame.origin.y, 50.0, 50.0);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self startAnimating:planeId+1];
        });
    }
}

- (void)show:(void (^)(void))completion
{
    self.alpha = 0.0;
    isActive = YES;
    [self startAnimating:1];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        completion();
    }];
}

- (void)dismiss:(void (^)(void))completion
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self->isActive = NO;
        if (completion) {
            completion();
        }
    }];
}

@end


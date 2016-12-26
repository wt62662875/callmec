#import <MAMapKit/MAMapKit.h>

/**
 *  可以在路径上进行移动动画的annoationView。
 */
@interface MovingAnnotationView : MAAnnotationView

- (void)addTrackingAnimationForCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSUInteger)count duration:(CFTimeInterval)duration;

@end

// UIImage+Alpha.h
// Created by Trevor Harmon on 9/20/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.


// NOTE: BeerShift modified to convert from Category to 
// new Class name since iPhone seems to have some issues with Categories
// of built in Classes


// Helper methods for adding an alpha layer to an image
@interface UIImageAlpha : NSObject
{
}
+ (BOOL)hasAlpha:(UIImage*)image;
+ (UIImage *)imageWithAlpha:(UIImage*)image;
+ (UIImage *)transparentBorderImage:(NSUInteger)borderSize image:(UIImage*)image;
@end

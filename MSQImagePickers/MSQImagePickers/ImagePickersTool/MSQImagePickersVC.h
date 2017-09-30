//
//  MSQImagePickersVC.h
//  MSQImagePickers
//
//  Created by 毛韶谦 on 2017/9/25.
//  Copyright © 2017年 毛韶谦. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSQImagePickersVC ;

@protocol MSQImageClipDelegate <NSObject>
/**
 图片处理完毕后调用
 
 @param clipViewController 回调的控制器
 @param editedImage 处理过的图片
 */
- (void)imageCropper:(MSQImagePickersVC *)clipViewController didFinished:(UIImage *)editedImage;
/**
 点击取消回调
 
 @param clipViewController 回调控制器
 */
- (void)imageCropperDidCancel:(MSQImagePickersVC *)clipViewController;

@end


@interface MSQImagePickersVC : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, weak) id<MSQImageClipDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;


/**
 初始化图片处理器

 @param originalImage 需要处理的图片
 @param cropFrame 编辑框的位置与大小
 @param limitRatio 可放大几倍
 @return 返回跳转控制器
 */
- (instancetype)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end

//
//  ViewController.m
//  MSQImagePickers
//
//  Created by 毛韶谦 on 2017/9/25.
//  Copyright © 2017年 毛韶谦. All rights reserved.
//

#import "ViewController.h"
#import "MSQImagePickersVC.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MSQImageClipDelegate>

@property (nonatomic, strong)UIImageView *showImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加图片";
    
    self.showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.showImageView.layer.cornerRadius = 4;
    self.showImageView.layer.masksToBounds = YES;
    self.showImageView.layer.borderColor = [UIColor redColor].CGColor;
    self.showImageView.layer.borderWidth = 2;
    [self.showImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:self.showImageView];
    
    UIButton *addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addImageButton.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 45);
    addImageButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 75);
    addImageButton.backgroundColor = [self hexColor:0x2CBCFF];
    addImageButton.layer.cornerRadius = 4;
    addImageButton.layer.masksToBounds = YES;
    [addImageButton setTitle:@"添加图片" forState:UIControlStateNormal];
    [addImageButton addTarget:self action:@selector(AddImageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addImageButton];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)AddImageAction:(UIButton *)sender {
    
    UIDevice *device = [UIDevice currentDevice];
    NSLog(@"name = %@", device.name);
    NSLog(@"model = %@", device.model);
    NSLog(@"localizedModel = %@", device.localizedModel);
    NSLog(@"systemName = %@", device.systemName);
    NSLog(@"systemVersion = %@", device.systemVersion);
    NSLog(@"orientation = %ld", (long)device.orientation);
    NSLog(@"identifierForVendor = %@", device.identifierForVendor);
    NSLog(@"systemVersion = %@", device.systemVersion);
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [bundle infoDictionary];
    
    for (id name in infoDictionary.allValues) {
        NSLog(@"%@\n",name);
    }
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = info.subscriberCellularProvider;
    
    NSLog(@"运营商:%@", carrier.carrierName);
    
/*
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertActionCamera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"相机");
        [self clickedButtonAtIndex:0];
    }];
    UIAlertAction *alertActionAlbum = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"相册");
        [self clickedButtonAtIndex:1];
    }];
    UIAlertAction *alertActionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [alertC addAction:alertActionCamera];
    [alertC addAction:alertActionAlbum];
    [alertC addAction:alertActionCancle];
    [self presentViewController:alertC animated:true completion:^{
        
    }];
 */
}


- (void)FinishPickingMediaWithImage:(UIImage *)image {
    
    
    
    
}

/**
 选择相机或相册

 @param buttonIndex 0--相机  2--相册
 */
- (void)clickedButtonAtIndex:(NSInteger)buttonIndex {
    
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
        } else {
            if (buttonIndex == 2) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        imagePickerController.sourceType = sourceType;
     
        [self presentViewController:imagePickerController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }];
}

#pragma mark ----系统图片选择器代理方法-----
//选择器完成选择
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    MSQImagePickersVC *vc = [[MSQImagePickersVC alloc] initWithImage:image cropFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3];
    vc.delegate = self;
    [picker pushViewController:vc animated:true];
}
//选择器取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark ----图片加工器MSQImagePickersVC代理方法------
/**
 图片处理完毕后调用

 @param clipViewController 回调的控制器
 @param editedImage 处理过的图片
 */
- (void)imageCropper:(MSQImagePickersVC *)clipViewController didFinished:(UIImage *)editedImage {
    
    self.showImageView.image = editedImage;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [clipViewController dismissViewControllerAnimated:true completion:^{
        
    }];
}

/**
 点击取消回调

 @param clipViewController 回调控制器
 */
- (void)imageCropperDidCancel:(MSQImagePickersVC *)clipViewController; {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [clipViewController dismissViewControllerAnimated:true completion:^{
        
    }];
}

#pragma mark ----方法-----
/**
 十六进制色值转换

 @param hexValue 十六进制色值
 @return 返回颜色
 */
- (UIColor*) hexColor:(NSInteger)hexValue {
    
    CGFloat red = (CGFloat)((hexValue & 0xFF0000) >> 16) / 255.0;
    CGFloat green = (CGFloat)((hexValue & 0xFF00) >> 8) /255.0;
    CGFloat blue = (CGFloat)(hexValue & 0xFF) / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    return color;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

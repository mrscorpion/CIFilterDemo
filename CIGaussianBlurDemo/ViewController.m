//
//  ViewController.m
//  CIGaussianBlurDemo
//
//  Created by 清风 on 16/7/19.
//  Copyright © 2016年 mrscorpion. All rights reserved.
//

#import "ViewController.h"
#import "BlurViewController.h"

typedef NS_ENUM(NSUInteger, MSStyle) {
    SepiaTone = 0, // 旧色调
    GaussianBlur // 模糊设置
};

@interface ViewController ()
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, assign) MSStyle type;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    _image = [UIImage imageNamed:@"immersion_mode"];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 150, 200, 300)];
    [_imageView setImage:_image];
    [self.view addSubview:_imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 280, 20)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"先选中按钮，再拖动滑块即可达到想要的效果";
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:label];
    
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(50, 50, 200, 40)];
    _slider.maximumValue = 1.0;
    _slider.minimumValue = 0;
    _slider.continuous =YES;
    [_slider addTarget:self action:@selector(valueChange)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
    
    _segmentControl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(80, 80, 120, 40)];
    [_segmentControl insertSegmentWithTitle:@"旧色调" atIndex:0 animated:YES];
    [_segmentControl insertSegmentWithTitle:@"模糊设置" atIndex:1 animated:YES];
    [_segmentControl addTarget:self action:@selector(ButtonAction)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentControl];
    
    
//    self.view.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentToNext)];
//    tap.numberOfTapsRequired = 2;
////    [self.imageView addGestureRecognizer:tap];
//    [self.view addGestureRecognizer:tap];
}
- (void)presentToNext
{
    [self presentViewController:[BlurViewController new] animated:YES completion:nil];
}
- (void)ButtonAction
{
    switch (_segmentControl.selectedSegmentIndex) {
        case 0:
        {
            self.type = SepiaTone;//旧色调
        }
            break;
            
        default:
        {
            self.type = GaussianBlur;//模糊设置
        }
            break;
    }
}
- (void)valueChange
{
    switch (self.type) {
        case SepiaTone:
        {
            //旧色调
            [self filterSepiaTone];
        }
            break;
            
        default:
        {
            //模糊设置
            [self filterGaussianBlur];
        }
            break;
    }
}
// 旧色调处理
- (void)filterSepiaTone
{
    //创建CIContext对象(默认值，传入nil)
    CIContext * context = [CIContext contextWithOptions:nil];
    //获取图片
    CIImage * cimage = [CIImage imageWithCGImage:[_image CGImage]];
    //创建CIFilter
    CIFilter * sepiaTone = [CIFilter filterWithName:@"CISepiaTone"];
    //设置滤镜输入参数
    [sepiaTone setValue:cimage forKey:@"inputImage"];
    
    //获取滑块的Value，设置色调强度
    [sepiaTone setValue:[NSNumber numberWithFloat:[_slider value]] forKey:@"inputIntensity"];
    //创建处理后的图片
    CIImage * resultImage = [sepiaTone valueForKey:@"outputImage"];
    CGImageRef imageRef = [context createCGImage:resultImage fromRect:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
    UIImage * image = [[UIImage alloc] initWithCGImage:imageRef];
    [_imageView setImage:image];
    CFRelease(imageRef);
}
// 模糊设置处理
- (void)filterGaussianBlur
{
    NSLog(@"slider -> %f", _slider.value * 10);
    //创建CIContext对象
    CIContext * context = [CIContext contextWithOptions:nil];
    //获取图片
    CIImage * image = [CIImage imageWithCGImage:[_image CGImage]];
    //创建CIFilter
    CIFilter * gaussianBlur = [CIFilter filterWithName:@"CIGaussianBlur"];
    //设置滤镜输入参数
    [gaussianBlur setValue:image forKey:@"inputImage"];
    //设置模糊参数
    [gaussianBlur setValue:[NSNumber numberWithFloat:_slider.value * 10] forKey:@"inputRadius"];
    
    //得到处理后的图片
    CIImage* resultImage = [gaussianBlur valueForKey:@"outputImage"];
    CGImageRef imageRef = [context createCGImage:resultImage fromRect:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
    UIImage * imge = [[UIImage alloc] initWithCGImage:imageRef];
    [_imageView setImage:imge];
    CFRelease(imageRef);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

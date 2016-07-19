//
//  BlurViewController.m
//  CIGaussianBlurDemo
//
//  Created by 清风 on 16/7/19.
//  Copyright © 2016年 mrscorpion. All rights reserved.
//

#import "BlurViewController.h"

@interface BlurViewController ()
{
    CGFloat wave;
}
@property (nonatomic, strong) NSTimer *timer; // 定时器
@property (strong, nonatomic) UIImageView *backImage; // 第二层的image
@end

@implementation BlurViewController
- (NSTimer *)timer
{
    if (!_timer) {
        self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(filterGaussianBlur) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    wave = 0.0;
    [self.timer fire];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    wave = 0.0;
    if (_timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.backImage setImage:[UIImage imageNamed:@"immersion_mode"]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 567)];
    self.backImage.image = [UIImage imageNamed:@"immersion_mode"];
    [self.view addSubview:self.backImage];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    NSInteger waveNum = 0;
    // fabs函数 : 求绝对值函数，fabs(x)，求出x的绝对值
    waveNum = 2 * (height/2 -fabs(height/2 - point.y)) / height * 10; //8;
    if (waveNum < 1) {
        waveNum = 1;
    }
//    [self filterGaussianBlurValue:waveNum];
    
    
    CGFloat value = 2 * (height/2 -fabs(height/2 - point.y)) / height * 10;
    wave = value;
//    CGFloat value = 2 * (height/2 -fabs(height/2 - point.y)) / height * 10;
    
//    NSLog(@"value --> %f", value);
//    [self filterGaussianBlurValue:value];
}
// 模糊设置处理
- (void)filterGaussianBlur
{
    //创建CIContext对象
    CIContext * context = [CIContext contextWithOptions:nil];
    //获取图片
    CIImage * image = [CIImage imageWithCGImage:[self.backImage.image CGImage]];
    //创建CIFilter
    CIFilter * gaussianBlur = [CIFilter filterWithName:@"CIGaussianBlur"];
    //设置滤镜输入参数
    [gaussianBlur setValue:image forKey:@"inputImage"];
    //设置模糊参数
    [gaussianBlur setValue:[NSNumber numberWithFloat:wave] forKey:@"inputRadius"];
    
    //得到处理后的图片
    CIImage* resultImage = [gaussianBlur valueForKey:@"outputImage"];
    CGImageRef imageRef = [context createCGImage:resultImage fromRect:CGRectMake(0, 0, self.backImage.frame.size.width, self.backImage.frame.size.height)];
    UIImage * imge = [[UIImage alloc] initWithCGImage:imageRef];
    [self.backImage setImage:imge];
    CFRelease(imageRef);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

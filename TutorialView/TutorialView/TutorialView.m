//
//  TutorialHandler.m
//  Minimarket
//
//  Created by Samat on 25.02.17.
//  Copyright © 2017 Samat. All rights reserved.
//

#import "TutorialView.h"

@implementation TutorialView {
    TutorialTappedBlock circleTapped;
    UIView *currentTutorialView;
    UIViewController *vc;
    NSString *labelText;
}

+ (id)sharedInstance {
    static TutorialView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#define buttonWidth 88
#define buttonHeight 36
#define touchImageWidth 40

- (void)addTutorialViewIfNotShownPreviouslyWithBackgroundColor:(UIColor *)backgroundColor text:(NSString *)text circleCenter:(CGPoint)circleCenter circleRaduis:(CGFloat)circleRaduis withTapAction:(TutorialTappedBlock)localTapAction inVC:(UIViewController *)localVC {
    if ([self showedInViewControllerClass:[localVC class] withText:text]) {
        return;
    }
    
    if ([self showedEverywhere]) {
        return;
    }
    
    vc = localVC;
    labelText = text;
    circleTapped = localTapAction;
    
    CGRect circleFrame = CGRectMake(circleCenter.x-circleRaduis, circleCenter.y-circleRaduis, circleRaduis*2, circleRaduis*2);
    UIImageView *tutorialImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    tutorialImageView.image = [self createImageWithColor:backgroundColor andCircleInFrame:circleFrame];
    tutorialImageView.userInteractionEnabled = YES;
    
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width-32-touchImageWidth-16;
    
    UIFont *labelFont;
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.2) {
        labelFont = [UIFont systemFontOfSize:18.0 weight:UIFontWeightLight];
    } else {
        labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
    }
    
    CGFloat labelHeight = [self calculateHeightForString:text withFont:labelFont width:labelWidth];

    CGFloat yForSkipAndOKButton = [UIScreen mainScreen].bounds.size.height-buttonHeight-16;
    
    CGFloat yForLabel = circleCenter.y+circleRaduis+16;
    
    CGFloat bottomOfCircle = circleCenter.y+circleRaduis;
    
    BOOL circleAtBottom = NO;
    //in case when circle is at the bottom
    if (yForSkipAndOKButton-bottomOfCircle<16) {
        yForSkipAndOKButton = circleCenter.y-circleRaduis-16-buttonHeight-16-labelHeight;
        yForLabel = circleCenter.y-circleRaduis-16-labelHeight;
        circleAtBottom = YES;
    }
    
    if (yForLabel+labelHeight+16>yForSkipAndOKButton && !circleAtBottom) {
        yForLabel = circleCenter.y-circleRaduis-16-labelHeight;
    }
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-buttonWidth-16, yForSkipAndOKButton, buttonWidth, buttonHeight)];
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    [okButton setBackgroundColor:[UIColor whiteColor]];
    [okButton addTarget:self action:@selector(okTapped) forControlEvents:UIControlEventTouchUpInside];
    [okButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
    okButton.layer.cornerRadius = 4;
    
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.2) {
        okButton.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:0.25];
    } else {
        okButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    }
    
    UIButton *skipButton = [[UIButton alloc] initWithFrame:CGRectMake(0, yForSkipAndOKButton, [UIScreen mainScreen].bounds.size.width - buttonWidth-16, buttonHeight)];
    [skipButton setTitle:@"SKIP TUTORIAL" forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(skipTutorialTapped) forControlEvents:UIControlEventTouchUpInside];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    skipButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    skipButton.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.2) {
        skipButton.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:0.25];
    } else {
        skipButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    }
    
    UIButton *circleTapButton = [[UIButton alloc] initWithFrame:circleFrame];
    [circleTapButton addTarget:self action:@selector(circleTapped) forControlEvents:UIControlEventTouchUpInside];
    [circleTapButton setTitle:@"" forState:UIControlStateNormal];
    
    CGRect labelFrame = CGRectMake(16+touchImageWidth+16, yForLabel, labelWidth, labelHeight);
    
    UIImageView *touchImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, yForLabel, touchImageWidth, touchImageWidth)];
    [touchImage setBackgroundColor:[self darkerColor:backgroundColor]];
    touchImage.layer.cornerRadius = touchImageWidth/2;
    touchImage.clipsToBounds = YES;
    [touchImage setImage:[UIImage imageNamed:@"ic_touch_app"]];
    touchImage.contentMode = UIViewContentModeCenter;
    
    UILabel *tutorialText = [[UILabel alloc] initWithFrame:labelFrame];
    tutorialText.textColor = [UIColor whiteColor];
    
    tutorialText.font = labelFont;
    
    tutorialText.text = text;
    tutorialText.numberOfLines = 0;
    
    [tutorialImageView addSubview:skipButton];
    [tutorialImageView addSubview:okButton];
    [tutorialImageView addSubview:circleTapButton];
    [tutorialImageView addSubview:tutorialText];
    [tutorialImageView addSubview:touchImage];
    
    currentTutorialView = tutorialImageView;
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:tutorialImageView];
}

- (UIColor *)darkerColor:(UIColor *)color
{
    CGFloat h, s, b, a;
    if ([color getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.95
                               alpha:a];
    return nil;
}

- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)createImageWithColor:(UIColor *)color andCircleInFrame:(CGRect)frame {
    UIScreen *screen = [UIScreen mainScreen];
    
    UIImage *sourceImage = [self imageFromColor:color];
    
    sourceImage = [self imageWithImage:sourceImage scaledToSize:CGSizeMake(screen.bounds.size.width, screen.bounds.size.height)];
    
    UIGraphicsBeginImageContextWithOptions(screen.bounds.size, NO, screen.scale);
    [sourceImage drawAtPoint:CGPointZero];
    
    UIImage *maskImage = [UIImage imageNamed:@"circleForTutorial.png"];
    
    maskImage = [self imageWithImage:maskImage scaledToSize:CGSizeMake(frame.size.width, frame.size.height)];
    
    [maskImage drawAtPoint:CGPointMake(frame.origin.x, frame.origin.y) blendMode:kCGBlendModeDestinationOut alpha:1.0f];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (float)calculateHeightForString:(NSString *)string withFont:(UIFont *)font width:(float)width {
    if ([string isEqualToString:@""] || string==nil) {
        return 0;
    }
    
    CGSize constrainedSize = CGSizeMake(width, 9999);
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          nil];
    
    NSMutableAttributedString *attributesString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributesDictionary];
    
    CGRect requiredHeight = [attributesString boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    if (requiredHeight.size.width > width) {
        requiredHeight = CGRectMake(0,0, width, requiredHeight.size.height);
    }
    
    return requiredHeight.size.height+5;
}

- (void)okTapped {
    [self setShowed:YES inViewControllerClass:[vc class] withText:labelText];
    [currentTutorialView removeFromSuperview];
}

- (void)skipTutorialTapped {
    [self setShowedEverywhere:YES];
    [currentTutorialView removeFromSuperview];
}

- (void)circleTapped {
    [self setShowed:YES inViewControllerClass:[vc class] withText:labelText];
    [currentTutorialView removeFromSuperview];
    circleTapped();
}

- (void)setShowed:(BOOL)showed inViewControllerClass:(Class)vcClass withText:(NSString *)text {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *value = (showed) ? @"YES" : @"NO";

    // Storing an NSString:
    NSString *classString = NSStringFromClass(vcClass);
    NSString *key = [NSString stringWithFormat:@"%@_%@", classString, text];

    [prefs setObject:value forKey:key];
    [prefs synchronize];
}

- (BOOL)showedInViewControllerClass:(Class)vcClass withText:(NSString *)text {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *classString = NSStringFromClass(vcClass);
    NSString *key = [NSString stringWithFormat:@"%@_%@", classString, text];
    NSString *value = [prefs stringForKey:key];
    
    if ([value isEqualToString:@""] || [value isEqualToString:@"NO"] || value==nil) {
        return NO;
    } else {
        return YES;
    }
}

- (void)setShowedEverywhere:(BOOL)showed {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *value = (showed) ? @"YES" : @"NO";
    
    // Storing an NSString:
    [prefs setObject:value forKey:@"showedEverywhere"];
    [prefs synchronize];
}

- (BOOL)showedEverywhere {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *value = [prefs stringForKey:@"showedEverywhere"];
    
    if ([value isEqualToString:@""] || [value isEqualToString:@"NO"] || value==nil) {
        return NO;
    } else {
        return YES;
    }
}

@end

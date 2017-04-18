//
//  ViewController.m
//  TutorialView
//
//  Created by Samat on 18.04.17.
//  Copyright © 2017 Samat. All rights reserved.
//

#import "ViewController.h"
#import "TutorialView.h"

@interface ViewController ()

@end

@implementation ViewController {
    CGSize screenSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    screenSize = [UIScreen mainScreen].bounds.size;
}

- (IBAction)showYellowTutorialWithBasicState:(id)sender {
    NSString *text = @"This is yellow tutorial slide with basic state";
    
    [[TutorialView sharedInstance] setShowed:NO inViewControllerClass:[self class] withText:text];
    
    [[TutorialView sharedInstance] addTutorialViewIfNotShownPreviouslyWithBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:200.0/255.0 blue:0.0/255.0 alpha:0.8] text:text circleCenter:CGPointMake(screenSize.width/2, screenSize.height/2) circleRaduis:30 withTapAction:^{
        [[[UIAlertView alloc] initWithTitle:@"Circle tapped" message:@"User tapped circle, you can do whatever you want instead of showing this alert view" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    } inVC:self];
}

- (IBAction)showBlueTutorialWhenCircleIsAlmostAtTheBottom:(id)sender {
    NSString *text = @"This is blue tutorial slide with state when highlighted circle is almost at the bottom";
    
    [[TutorialView sharedInstance] setShowed:NO inViewControllerClass:[self class] withText:text];

    [[TutorialView sharedInstance] addTutorialViewIfNotShownPreviouslyWithBackgroundColor:[UIColor colorWithRed:35.0/255.0 green:126.0/255.0 blue:232.0/255.0 alpha:0.8] text:text circleCenter:CGPointMake(screenSize.width/2, screenSize.height-100) circleRaduis:30 withTapAction:^{
        [[[UIAlertView alloc] initWithTitle:@"Circle tapped" message:@"User tapped circle, you can do whatever you want instead of showing this alert view" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    } inVC:self];
}

- (IBAction)showRedTutorialWhenCircleIsAtTheBottom:(id)sender {
    NSString *text = @"This is red tutorial slide with state when highlighted circle is almost touching bottom";
    
    [[TutorialView sharedInstance] setShowed:NO inViewControllerClass:[self class] withText:text];

    [[TutorialView sharedInstance] addTutorialViewIfNotShownPreviouslyWithBackgroundColor:[UIColor colorWithRed:213.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.8] text:text circleCenter:CGPointMake(screenSize.width/2, screenSize.height-46) circleRaduis:30 withTapAction:^{
        [[[UIAlertView alloc] initWithTitle:@"Circle tapped" message:@"User tapped circle, you can do whatever you want instead of showing this alert view" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    } inVC:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

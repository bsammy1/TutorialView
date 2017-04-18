//
//  TutorialHandler.h
//  Minimarket
//
//  Created by Samat on 25.02.17.
//  Copyright © 2017 Samat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TutorialView : NSObject

typedef void (^TutorialTappedBlock)();

+ (id)sharedInstance;

- (void)addTutorialViewIfNotShownPreviouslyWithBackgroundColor:(UIColor *)backgroundColor text:(NSString *)text circleCenter:(CGPoint)circleCenter circleRaduis:(CGFloat)circleRaduis withTapAction:(TutorialTappedBlock)localTapAction inVC:(UIViewController *)localVC;

- (void)setShowed:(BOOL)showed inViewControllerClass:(Class)vcClass withText:(NSString *)text;

- (BOOL)showedInViewControllerClass:(Class)vcClass withText:(NSString *)text;

- (void)setShowedEverywhere:(BOOL)showed;

@end

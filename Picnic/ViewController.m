//
//  ViewController.m
//  Picnic
//
//  Created by xzhou on 10/17/13.
//  Copyright (c) 2013 xzhou. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bug;
@property (nonatomic,weak) IBOutlet UIImageView *basketTop;
@property (nonatomic,weak) IBOutlet UIImageView *basketBottom;
@property (nonatomic,weak) IBOutlet UIImageView *fabricTop;
@property (nonatomic,weak) IBOutlet UIImageView *fabricBottom;
@end

@implementation ViewController{
    bool bugDead;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    
    CGRect basketTopFrame = self.basketTop.frame;
    basketTopFrame.origin.y = -basketTopFrame.size.height;
    
    CGRect basketBottomFrame = self.basketBottom.frame;
    basketBottomFrame.origin.y = self.view.bounds.size.height;
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationDelay:1.0];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.basketTop.frame = basketTopFrame;
                         self.basketBottom.frame = basketBottomFrame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Open basket!");
                     }];
    
    [self moveFabric:YES];
    [self moveToLeft:nil finished:nil context:nil];

}

-(void)moveFabric:(BOOL)animated
{
    CGRect fabricTopFrame = self.fabricTop.frame;
    fabricTopFrame.origin.y = -fabricTopFrame.size.height;
    
    CGRect fabricBottomFrame = self.fabricBottom.frame;
    fabricBottomFrame.origin.y = self.view.bounds.size.height;
    
    [UIView animateWithDuration:1.0
                          delay:1.5
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.fabricTop.frame = fabricTopFrame;
                         self.fabricBottom.frame = fabricBottomFrame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"I am in fabric");
                     }];
    
}

- (void)moveToLeft:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (bugDead) return;
    [UIView animateWithDuration:2.0
                          delay:2.0
                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(faceRight:finished:context:)];
                         self.bug.center = CGPointMake(75, 200);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Move to left done");
                     }];
    
}

- (void)faceRight:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (bugDead) return;
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(moveToRight:finished:context:)];
                         
                         self.bug.transform = CGAffineTransformMakeRotation(M_PI);
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Face right done");
                     }];
    
}

- (void)moveToRight:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (bugDead) return;
    [UIView animateWithDuration:2.0
                          delay:2.0
                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(faceLeft:finished:context:)];
                         self.bug.center = CGPointMake(230, 250);
                         
                     }
                     completion:^(BOOL finished){
                         
                         NSLog(@"Move to right done");
                     }];
    
}

- (void)faceLeft:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (bugDead) return;
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         
                         [UIView setAnimationDidStopSelector:@selector(moveToLeft:finished:context:)];
                         self.bug.transform = CGAffineTransformMakeRotation(0);
                         
                         
                     }completion:^(BOOL finished){
                         NSLog(@"Face left done");
                         
                     }];
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    CGRect bugRect = [[[self.bug layer] presentationLayer] frame];
    if (CGRectContainsPoint(bugRect, touchLocation)) {
        NSLog(@"Bug tapped!");
        bugDead = true;
        [UIView animateWithDuration:0.7
                              delay:0.0
                            options:UIViewAnimationCurveEaseOut
                         animations:^{
                             self.bug.transform = CGAffineTransformMakeScale(1.25, 0.75);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:2.0
                                                   delay:2.0
                                                 options:0
                                              animations:^{
                                                  self.bug.alpha = 0.0;
                                              } completion:^(BOOL finished) {
                                                  [self.bug removeFromSuperview];
                                              }];
                         }];
        
    } else {
        NSLog(@"Bug not tapped.");
        return;
    }
    
    NSString *squishPath = [[NSBundle mainBundle]
                            pathForResource:@"squish" ofType:@"caf"];
    NSURL *squishURL = [NSURL fileURLWithPath:squishPath];
    SystemSoundID squishSoundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)squishURL, &squishSoundID);
    AudioServicesPlaySystemSound(squishSoundID);
    
}

@end

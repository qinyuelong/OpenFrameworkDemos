//
//  ProfileButton.h
//  MyStarWars
//
//  Created by snqu-ios on 16/6/13.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionBlock)();

@interface ProfileButton : UIButton

-(void)animateTouchUpInside:(CompletionBlock)completionBlock;

@end

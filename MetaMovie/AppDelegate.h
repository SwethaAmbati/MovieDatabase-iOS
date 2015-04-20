//
//  AppDelegate.h
//  MetaMovie
//
//  Created by Swetha Ambati on 4/3/15.
//  Copyright (c) 2015 Swetha Ambati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *data))completionHandler;



@end


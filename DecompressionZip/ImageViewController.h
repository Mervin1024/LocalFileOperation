//
//  ImageViewController.h
//  DecompressionZip
//
//  Created by sh219 on 15/11/26.
//  Copyright © 2015年 sh219. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BankButtonType) {
    BankButtonTypeDismiss,
    BankButtonTypeRevoke
};

@interface FilePath : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *childPaths;
@property (copy, nonatomic) UIImage *image;

@end

@interface ImageViewController : UIViewController

@property (strong, nonatomic) NSArray *directories;
@property (copy, nonatomic) NSString *directoryPath;
@property (assign, nonatomic) BOOL isRoot;
@end

//
// Copyright (c) 2017 MediaMonks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NNView.h"

FOUNDATION_EXPORT NSString *const kShowModal;
FOUNDATION_EXPORT NSString *const kDismiss;
FOUNDATION_EXPORT NSString *const kUpdateStyle;

@class NNSingleNode;


@interface NNSingleView : UIViewController <NNView>

@property(nonatomic, strong, readonly) NNSingleNode *singleNode;

- (instancetype)initWithBridge:(RCTBridge *)bridge node:(NNSingleNode *)node;

@end

@interface UIViewController (Modal)

@property(nullable, nonatomic, strong) NNSingleView *modalPresenter;

@end

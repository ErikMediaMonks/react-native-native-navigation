//
// Copyright (c) 2017 MediaMonks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NNView.h"

FOUNDATION_EXPORT NSString *const kPush;

@class NNStackNode;

@interface NNStackView : UINavigationController <NNView>

- (instancetype)initWithNode:(NNStackNode *)node;

@end

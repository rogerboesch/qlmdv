
#import <Cocoa/Cocoa.h>

#import "RBKeyTextView.h"

@protocol RBEditingTextViewDelegate <NSTextViewDelegate>

- (BOOL)textView:(NSTextView *)textView doKeyDownByEvent:(NSEvent*)event;

@end

@interface RBEditingTextView : RBKeyTextView

@end

/**
  RBEditingTextView.h
  roboText

  Created by Roger Boesch on 11.03.18.
  Copyright © 2018 Roger Boesch. All rights reserved.
*/

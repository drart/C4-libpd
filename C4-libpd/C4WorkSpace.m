//
//  C4WorkSpace.m
//  C4-libpd
//
//  Created by Adam Tindale on 2013-02-20.
//  Copyright (c) 2013 Adam Tindale. All rights reserved.
//

#import "C4WorkSpace.h"


@implementation C4WorkSpace

-(void)setup {
    dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:dispatcher];
    patch = [PdBase openFile:@"test.pd"
                        path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"Failed to open patch!"); // Gracefully handle failure...
    }
    
    // this also works. pdbase manages having multiple patches
    [PdBase openFile:@"test.pd" path:[[NSBundle mainBundle] resourcePath]];

}


@end

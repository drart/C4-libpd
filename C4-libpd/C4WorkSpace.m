//
//  C4WorkSpace.m
//  C4-libpd
//
//  Created by Adam Tindale on 2013-02-20.
//  Copyright (c) 2013 Adam Tindale. All rights reserved.
//

#import "C4WorkSpace.h"
#import "C4PureData.h"

@implementation C4WorkSpace
C4PureData *pd;
C4PureData *pd2;

-(void)setup {
    /* // method 1
    pd = [[C4PureData alloc] init] ;
    [pd openPatch:@"test.pd"];
    [pd start];
     */
    
    // method 2
    pd = [[C4PureData alloc] initWithPatch:@"test.pd"];
    // open another patch!!!
    [pd openPatch:@"test2.pd"];

    //  this is a problem. must check for init.
    //pd2 = [[C4PureData alloc] initWithPatch:@"test.pd"];
    
    NSLog(@"Number of patches open: %d", [pd patchesOpen]);
}


@end

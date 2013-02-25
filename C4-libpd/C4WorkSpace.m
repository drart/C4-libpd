//
//  C4WorkSpace.m
//  C4-libpd
//
//  Created by Adam Tindale on 2013-02-20.
//  Copyright (c) 2013 Adam Tindale. All rights reserved.
//

#import "C4WorkSpace.h"
#import "C4PureData.h"
//#import "PdFile.h"

@implementation C4WorkSpace
C4PureData *pd;
C4PureData *pd2;
PdFile * ff;


-(void)setup {
    
    /* // method 1 for instantiating C4PD
    pd = [[C4PureData alloc] init] ;
    [pd openPatch:@"test.pd"];
     */
    
    // method 2
    pd = [[C4PureData alloc] initWithPatch:@"test.pd"];
    
    // open another patch!!!
    [pd openPatch:@"test2.pd"];

    //  this is a problem. must check for init.
    //pd2 = [[C4PureData alloc] initWithPatch:@"test.pd"];
    
    [pd printPatches];

    for (int i = [pd numberOfPatchesOpen]-1 ; i >= 0 ; i--)
    {
        [pd closePatch:i];
    }
    NSLog(@"Number of patches open: %d", [pd numberOfPatchesOpen]);
    
    sleep(1);
    [pd openPatch:@"test2.pd"];
        
    [PdBase sendFloat:0.0 toReceiver:@"left"];
    [pd sendFloatToAPatch:0.0 toReceiver:@"right" toPatch:0];
}

@end

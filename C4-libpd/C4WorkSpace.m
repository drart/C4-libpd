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

    pd = [[C4PureData alloc] initWithPatch:@"test.pd"];
    
    // open another patch!!!
    ff = [pd openPatch:@"test2.pd"];

    //  Now this will crash. Only have on C4PD in your
    //pd2 = [[C4PureData alloc] initWithPatch:@"test.pd"];
    
    [pd printPatches];

    for (int i = [pd numberOfPatchesOpen]-1 ; i >= 0 ; i--)
    {
        [pd closePatch:i];
    }
    NSLog(@"Number of patches open: %d", [pd numberOfPatchesOpen]);
    
    sleep(1);
    [pd openPatch:@"test2.pd"];
        
    [PdBase sendFloat:0.4 toReceiver:@"left"];
    [pd sendFloatToAPatch:0.4 toReceiver:@"right" toPatch:0];
}

@end

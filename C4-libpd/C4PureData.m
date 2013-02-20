//
//  C4PureData.m
//  C4-libpd
//
//  Created by Adam Tindale on 2013-02-20.
//  Copyright (c) 2013 Adam Tindale. All rights reserved.
//

#import "C4PureData.h"

@implementation C4PureData
@synthesize audioController = _audioController;

-(BOOL) initPD{
    _audioController = [[PdAudioController alloc] init];
    if ([self.audioController configureAmbientWithSampleRate:44100
                                          numberChannels:2 mixingEnabled:YES] != PdAudioOK)
    {
        NSLog(@"failed to initialize audio components");
        return NO;
    }
    
    [self.audioController setActive:YES];
   
    return YES;
}

-(BOOL) addPatch {
    dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:dispatcher];
    patch = [PdBase openFile:@"test.pd"
                        path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"Failed to open patch!"); // Gracefully handle failure...
        return NO;
    }
    
    return YES;
}

-(void) startPD{
    self.audioController.active = YES;
}

-(void) stopPD{
    self.audioController.active = NO;
}



@end

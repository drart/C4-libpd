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
//@synthesize dispatcher = _dispatcher;

-(C4PureData *) init
{
    _audioController = [[PdAudioController alloc] init];
    if ([self.audioController configureAmbientWithSampleRate:44100 numberChannels:2 mixingEnabled:YES] != PdAudioOK)
    {
        NSLog(@"failed to initialize audio components");
        exit(1); /// bad idea.
    }
    return self;
}

-(C4PureData *) initWithPatch: (NSString *) patch
{
    self = [self init];
    [self openPatch:patch];
    return self;
}


-(void) openPatch: (NSString *) patch
{
    dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:dispatcher];
    thepatch = [PdBase openFile:patch
                        path:[[NSBundle mainBundle] resourcePath]];
    if (!thepatch) {
        NSLog(@"Failed to open patch!"); // Gracefully handle failure...
    }
    
    [self start];
}

-(void) start
{
    self.audioController.active = YES;
}

-(void) stop
{
    self.audioController.active = NO;
}

@end

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
//@synthesize dispatcher = _dispatcher; // should this be a parameter or an instance variable?

-(C4PureData *) init
{
    _audioController = [[PdAudioController alloc] init];
    if ([self.audioController configureAmbientWithSampleRate:44100 numberChannels:2 mixingEnabled:YES] != PdAudioOK)
    {
        NSLog(@"failed to initialize audio components");
        exit(1); /// bad idea.
    }
    
    patches = [[NSMutableArray alloc] init];
    return self;
}

-(C4PureData *) initWithPatch: (NSString *) patchName
{
    self = [self init];
    [self openPatch:patchName];
    return self;
}
-(void) start
{
    self.audioController.active = YES;
}

-(void) stop
{
    self.audioController.active = NO;
}

-(void) openPatch: (NSString *) patchName
{
    dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:dispatcher];
    PdFile * pdpatch = [PdFile openFileNamed:patchName path:[[NSBundle mainBundle] resourcePath]];
    if (!pdpatch) {
        NSLog(@"Failed to open patch!"); // Gracefully handle failure...
    }

    [patches addObject:pdpatch];
    [self start];
}

-(void) closePatch: (int) index
{
    [patches[index] closeFile];
}

-(int) patchesOpen
{
    return [patches count];
}

@end

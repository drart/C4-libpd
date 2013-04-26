//
//  C4PD.m
//  C4-libpd
//
//  Created by Adam Tindale on 2013-04-04.
//  Copyright (c) 2013 Adam Tindale. All rights reserved.
//

#import "C4PD.h"

@implementation C4PD

-(void) setup
{
    self.audioController = [[AEAudioController alloc]
                            initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription]
                            inputEnabled:YES];
    NSError *error = NULL;
    BOOL result = [_audioController start:&error];
    if(!result)
    {
        C4Log(@"%@", error);
    }
    
    self.channel = [AEBlockChannel channelWithBlock:^(const AudioTimeStamp  *time,
                                                      UInt32           frames,
                                                      AudioBufferList *audio) {
        // TODO: Generate audio in 'audio'
    }];
}

@end

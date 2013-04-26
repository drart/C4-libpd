//
//  C4PD.h
//  C4-libpd
//
//  Created by Adam Tindale on 2013-04-04.
//  Copyright (c) 2013 Adam Tindale. All rights reserved.
//

#import "C4Object.h"
#import "AEAudioController.h"

@interface C4PD : C4Object

@property (nonatomic, strong) AEAudioController *audioController;

@end

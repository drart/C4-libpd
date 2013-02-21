C4-libpd
=========

A working attempt to merge libpd with C4. 

Getting Started
================

On the command line type:

    git clone git@github.com:drart/C4-libpd.git
    cd C4-libpd/
    git submodule init
    git submodule update
    open .

- Click on the XCODE project. 
- Select the C4-libpd scheme and run it on either the simulator or your device
- Enjoy!
- Hack!
- Email me.


LOG
========

- Created xcode project
- Added git submodule git://github.com/libpd/libpd.git
- Added to root project
- Changed relative search headers  $(SRCROOT)/../../ libpd
- ibpd-ios as a dependency 
- added AudioToolbox.framework
- Put PDAudioController in C4AppDelegateh/m

TODO
======

- Make C4PD static or prevent multiple instantiations of PDAudioController
- Make a real log file

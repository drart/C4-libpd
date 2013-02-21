C4-libpd
=========


A working attempt to merge libpd with C4. 




- Created xcode project
- Added git submodule git://github.com/libpd/libpd.git
- Added to root project
- Changed relative search headers  $(SRCROOT)/../../ libpd
- ibpd-ios as a dependency 
- added AudioToolbox.framework
- Put PDAudioController in C4AppDelegateh/m

TODO
======

- Where appdelegate and viewcontroller in C4? How do I copy code from other tutorials?
- Make a C4PureData class
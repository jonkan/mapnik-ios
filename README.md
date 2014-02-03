mapnik-ios
==========
An attempt to compile mapnik 2.2.0 for iOS.

To compile, run:
$ git submodule init
$ git submodule update
$ make

Note that this doesn't compile yet, see output below:

Welcome to Mapnik...

Configuring build environment...
Configuring on Darwin in *release mode*...
Checking for freetype-config... yes
Checking for xml2-config... yes
Checking for C library z... yes
Checking for C++ library icuuc... yes
Checking for C library jpeg... yes
Checking for C library proj... yes
Checking for C library png... yes
Checking for C library tiff... yes
sh: .sconf_temp/conftest_8: Bad CPU type in executable
Checking for ICU version >= 4.2... (cached) Searching for boost libs and headers... (cached) 
Found boost libs: <some-path>/mapnik-ios/build/armv7/lib
Found boost headers: <some-path>/mapnik-ios/build/armv7/include
Checking for C++ header file boost/version.hpp... yes
sh: .sconf_temp/conftest_10: Bad CPU type in executable
sh: .sconf_temp/conftest_11: Bad CPU type in executable
Checking for Boost version >= 1.47... no
Found boost lib version... 
Boost version 1.47 or greater is required
Checking for C++ library boost_system... yes
Checking for C++ library boost_filesystem... yes
Checking for C++ library boost_regex... yes
Checking for C++ library boost_program_options... yes
Checking for C++ library boost_thread... yes
Checking for pkg-config... yes
Checking for requested plugins dependencies...
Checking for cairo... no

Exiting... the following required dependencies were not found:
   - icuuc (ICU C++ library | configure with ICU_LIBS & ICU_INCLUDES or use ICU_LIB_NAME to specify custom lib name  | more info: http://site.icu-project.org/)
   - boost version >= 1.47 (more info see: https://github.com/mapnik/mapnik/wiki/Mapnik-Installation & http://www.boost.org)

See '<some-path>/mapnik-ios/mapnik/config.log' for details on possible problems.

Also, these OPTIONAL dependencies were not found:
   - cairo (Cairo C library | configured using pkg-config | try setting PKG_CONFIG_PATH SCons option)

Set custom paths to these libraries and header files on the command-line or in a file called 'config.py'
    ie. $ python scons/scons.py BOOST_INCLUDES=/usr/local/include BOOST_LIBS=/usr/local/lib

Once all required dependencies are found a local 'config.py' will be saved and then install:
    $ sudo python scons/scons.py install

To view available path variables:
    $ python scons/scons.py --help or -h

To view overall SCons help options:
    $ python scons/scons.py --help-options or -H

More info: https://github.com/mapnik/mapnik/wiki/Mapnik-Installation
make[1]: *** [<some-path>/mapnik-ios/build/armv7/lib/libmapnik.a] Error 1
make: *** [build_arches] Error 2

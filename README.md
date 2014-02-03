mapnik-ios<br/>
==========<br/>
An attempt to compile mapnik 2.2.0 for iOS.<br/>
<br/>
First run:<br/>
$ git submodule init<br/>
$ git submodule update<br/>
<br/>
Then apply the patch:<br/>
$ cp ios-v2.2.0.diff mapnik/<br/>
$ patch -p1 < ios-v2.2.0.diff<br/>
<br/>
To compile, run:<br/>
$ make<br/>
<br/>
Note that this doesn't compile yet, see output below:<br/>
<br/>
Welcome to Mapnik...<br/>
<br/>
Configuring build environment...<br/>
Configuring on Darwin in *release mode*...<br/>
Checking for freetype-config... yes<br/>
Checking for xml2-config... yes<br/>
Checking for C library z... yes<br/>
Checking for C++ library icuuc... yes<br/>
Checking for C library jpeg... yes<br/>
Checking for C library proj... yes<br/>
Checking for C library png... yes<br/>
Checking for C library tiff... yes<br/>
sh: .sconf_temp/conftest_8: Bad CPU type in executable<br/>
Checking for ICU version >= 4.2... (cached) Searching for boost libs and headers... (cached) <br/>
Found boost libs: <some-path>/mapnik-ios/build/armv7/lib<br/>
Found boost headers: <some-path>/mapnik-ios/build/armv7/include<br/>
Checking for C++ header file boost/version.hpp... yes<br/>
sh: .sconf_temp/conftest_10: Bad CPU type in executable<br/>
sh: .sconf_temp/conftest_11: Bad CPU type in executable<br/>
Checking for Boost version >= 1.47... no<br/>
Found boost lib version... <br/>
Boost version 1.47 or greater is required<br/>
Checking for C++ library boost_system... yes<br/>
Checking for C++ library boost_filesystem... yes<br/>
Checking for C++ library boost_regex... yes<br/>
Checking for C++ library boost_program_options... yes<br/>
Checking for C++ library boost_thread... yes<br/>
Checking for pkg-config... yes<br/>
Checking for requested plugins dependencies...<br/>
Checking for cairo... no<br/>
<br/>
Exiting... the following required dependencies were not found:<br/>
   - icuuc (ICU C++ library | configure with ICU_LIBS & ICU_INCLUDES or use ICU_LIB_NAME to specify custom lib name  | more info: http://site.icu-project.org/)<br/>
   - boost version >= 1.47 (more info see: https://github.com/mapnik/mapnik/wiki/Mapnik-Installation & http://www.boost.org)<br/>
<br/>
See '<some-path>/mapnik-ios/mapnik/config.log' for details on possible problems.<br/>
<br/>
Also, these OPTIONAL dependencies were not found:<br/>
   - cairo (Cairo C library | configured using pkg-config | try setting PKG_CONFIG_PATH SCons option)<br/>
<br/>
Set custom paths to these libraries and header files on the command-line or in a file called 'config.py'<br/>
    ie. $ python scons/scons.py BOOST_INCLUDES=/usr/local/include BOOST_LIBS=/usr/local/lib<br/>
<br/>
Once all required dependencies are found a local 'config.py' will be saved and then install:<br/>
    $ sudo python scons/scons.py install<br/>
<br/>
To view available path variables:<br/>
    $ python scons/scons.py --help or -h<br/>
<br/>
To view overall SCons help options:<br/>
    $ python scons/scons.py --help-options or -H<br/>
<br/>
More info: https://github.com/mapnik/mapnik/wiki/Mapnik-Installation<br/>
make[1]: *** [<some-path>/mapnik-ios/build/armv7/lib/libmapnik.a] Error 1<br/>
make: *** [build_arches] Error 2<br/>

mapnik-ios<br/>
==========<br/>
An attempt to compile mapnik 2.2.0 for iOS.<br/>
<br/>
First run:<br/>
$ git submodule init<br/>
$ git submodule update<br/>
<br/>
Then apply the patch:<br/>
$ cd mapnik<br/>
$ patch -p1 < ../mapnik_patch<br/>
<br/>
To compile, run:<br/>
$ make<br/>
<br/>
Note that this doesn't compile yet, you will probably get stuck on missing boost_regex/icu symbols.<br/>

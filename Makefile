
XCODE_DEVELOPER = $(shell xcode-select --print-path)
IOS_PLATFORM ?= iPhoneOS

IOS_PLATFORM_DEVELOPER = ${XCODE_DEVELOPER}/Platforms/${IOS_PLATFORM}.platform/Developer
IOS_SDK = ${IOS_PLATFORM_DEVELOPER}/SDKs/$(shell ls ${IOS_PLATFORM_DEVELOPER}/SDKs | sort -r | head -n1)

IPHONE_SDKVERSION = 7.0
BOOST_VERSION = 1.55.0
BOOST_VERSION2 = 1_55_0

all: lib/libmapnik.a
lib/libmapnik.a: build_arches
		mkdir -p lib
		mkdir -p include

		# Copy includes
		cp -R build/armv7/include/freetype2 include
		cp -R build/armv7/include/mapnik include
		cp -R build/armv7/include/boost include
		cp -R build/armv7/include/unicode include
		#cp -R build/armv7/include/cairomm-1.0/cairomm include
		#cp -R build/armv7/include/cairomm-1.0/cairomm include
		#cp -R build/armv7/include/sigc++-2.0/sigc++ include
		#cp libsigc++/sigc++config.h include/
		#cp build/armv7/include/cairo/*.h include/
		#cp -R build/armv7/include/fontconfig include/
		cp build/armv7/include/ft2build.h include
		cp build/armv7/include/proj_api.h include

		# Make fat libraries for all architectures
		for file in build/armv7/lib/*.a; \
				do name=`basename $$file .a`; \
				${IOS_PLATFORM_DEVELOPER}/usr/bin/lipo -create \
						-arch armv7 build/armv7/lib/$$name.a \
						-arch armv7s build/armv7s/lib/$$name.a \
						-arch i386 build/i386/lib/$$name.a \
						-output lib/$$name.a \
				; \
				done;
		echo "Making libmapnik or something"

build_arches:
		${MAKE} arch ARCH=armv7 IOS_PLATFORM=iPhoneOS
		#${MAKE} arch ARCH=armv7s IOS_PLATFORM=iPhoneOS
		#${MAKE} arch ARCH=i386 IOS_PLATFORM=iPhoneSimulator

PREFIX = ${CURDIR}/build/${ARCH}
LIBDIR = ${PREFIX}/lib
INCLUDEDIR = ${PREFIX}/include

#$(shell xcrun -find -sdk iphoneos clang)
CXX 		= ${XCODE_DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++
CC 			= ${XCODE_DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
AR 			= ${XCODE_DEVELOPER}/Platforms/iPhoneOS.platform/Developer/usr/bin/ar
CFLAGS 		= -isysroot ${IOS_SDK} -I${IOS_SDK}/usr/include -arch ${ARCH} -miphoneos-version-min=6.1
CXXFLAGS 	= -std=c++11 -stdlib=libc++ -isysroot ${IOS_SDK} -I${IOS_SDK}/usr/include -arch ${ARCH}  -miphoneos-version-min=6.1
LDFLAGS 	= -stdlib=libc++ -isysroot ${IOS_SDK} -L${LIBDIR} -L${IOS_SDK}/usr/lib -arch ${ARCH} -miphoneos-version-min=6.1

arch: ${LIBDIR}/libmapnik.a

${LIBDIR}/libmapnik.a: ${LIBDIR}/libpng.a ${LIBDIR}/libproj.a ${LIBDIR}/libtiff.a ${LIBDIR}/libjpeg.a ${LIBDIR}/libicuuc.a ${LIBDIR}/libboost_system.a ${LIBDIR}/libfreetype.a
	cd mapnik && ./configure CXX=${CXX} CC=${CC} \
			CUSTOM_CFLAGS="${CFLAGS} -I${IOS_SDK}/usr/include/libxml2" \
            CUSTOM_CXXFLAGS="${CXXFLAGS} -DUCHAR_TYPE=uint16_t -I${IOS_SDK}/usr/include/libxml2" \
            CUSTOM_LDFLAGS="${LDFLAGS}" \
            FREETYPE_CONFIG=${PREFIX}/bin/freetype-config \
            XML2_CONFIG=/usr/local/Cellar/libxml2/2.9.1/bin/xml2-config \
            {LTDL_INCLUDES,OCCI_INCLUDES,SQLITE_INCLUDES,RASTERLITE_INCLUDES}=. \
            {BOOST_PYTHON_LIB,LTDL_LIBS,OCCI_LIBS,SQLITE_LIBS,RASTERLITE_LIBS}=. \
            BOOST_INCLUDES=${PREFIX}/include \
			BOOST_LIBS=${PREFIX}/lib \
			ICU_INCLUDES=${PREFIX}/include \
			ICU_LIBS=${PREFIX}/lib \
			PROJ_INCLUDES=${PREFIX}/include \
			PROJ_LIBS=${PREFIX}/lib \
			PNG_INCLUDES=${PREFIX}/include \
			PNG_LIBS=${PREFIX}/lib \
			JPEG_INCLUDES=${PREFIX}/include \
			JPEG_LIBS=${PREFIX}/lib \
			TIFF_INCLUDES=${PREFIX}/include \
			TIFF_LIBS=${PREFIX}/lib \
            INPUT_PLUGINS=shape \
            BINDINGS=none \
            LINKING=static \
            DEMO=no \
            RUNTIME_LINK=static \
            PREFIX=${PREFIX} && make clean install

#CAIRO_INCLUDES=${PREFIX} \
#CAIRO_LIBS=${PREFIX} \
            
# LibPNG
${LIBDIR}/libpng.a:
	@if [! -s configure ]; then \
		./autogen.sh; \
	fi;
	cd libpng && env CXX=${CXX} CC=${CC} CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" ./configure --host=arm-apple-darwin --disable-shared --prefix=${PREFIX} && ${MAKE} clean install

# LibProj
${LIBDIR}/libproj.a:
	cd libproj && env CXX=${CXX} CC=${CC} CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" ./configure --host=arm-apple-darwin --disable-shared --prefix=${PREFIX} && ${MAKE} clean install

# LibTiff
${LIBDIR}/libtiff.a:
	cd libtiff && env CXX=${CXX} CC=${CC} CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" ./configure --host=arm-apple-darwin --disable-shared --prefix=${PREFIX} && ${MAKE} clean install

# LibJpeg
${LIBDIR}/libjpeg.a:
	cd libjpeg && env CXX=${CXX} CC=${CC} CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" ./configure --host=arm-apple-darwin --disable-shared --prefix=${PREFIX} && ${MAKE} clean install

# LibIcu
libicu_host/config/icucross.mk:
	cd libicu_host && ./configure && ${MAKE}

${LIBDIR}/libicuuc.a: libicu_host/config/icucross.mk
	touch ${CURDIR}/license.html
	cd libicu && env CXX=${CXX} CC=${CC} CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS} -I${CURDIR}/libicu/tools/tzcode -DUCHAR_TYPE=uint16_t" LDFLAGS="${LDFLAGS}" ./configure --host=arm-apple-darwin --disable-shared --enable-static --prefix=${PREFIX} --with-cross-build=${CURDIR}/libicu_host && ${MAKE} clean install

# Boost
${LIBDIR}/libboost_system.a: ${LIBDIR}/libicuuc.a
	@if [ ! -s boost_${BOOST_VERSION2}.tar.bz2 ]; then \
		echo "Downloading boost ${BOOST_VERSION}"; \
		curl -L -o boost_${BOOST_VERSION2}.tar.bz2 http://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/boost_${BOOST_VERSION2}.tar.bz2/download; \
	fi;
	@if [ ! -d "boost_${BOOST_VERSION2}" ]; then \
		echo "Unpacking boost ${BOOST_VERSION2}"; \
		tar -xzf boost_${BOOST_VERSION2}.tar.bz2; \
		cp boost_${BOOST_VERSION2}/tools/build/v2/user-config.jam boost_${BOOST_VERSION2}/tools/build/v2/user-config.jam-bk; \
	fi;
	cd boost_${BOOST_VERSION2} && rm -rf boost-build boost-stage
	cd boost_${BOOST_VERSION2} && ./bootstrap.sh --with-libraries=thread,signals,filesystem,regex,system,date_time,program_options
	cd boost_${BOOST_VERSION2} && cp tools/build/v2/user-config.jam-bk tools/build/v2/user-config.jam
	echo "using darwin : ${IPHONE_SDKVERSION}~iphone \n \
			: ${CXX} -arch armv7 ${CXXFLAGS} -I${INCLUDEDIR} -L${LIBDIR} -fvisibility=hidden -fvisibility-inlines-hidden -DBOOST_AC_USE_PTHREADS -DBOOST_SP_USE_PTHREADS \n \
			: <striper> <root>${XCODE_DEVELOPER}/Platforms/iPhoneOS.platform/Developer \n \
			: <architecture>arm <target-os>iphone \n \
			;" >> boost_${BOOST_VERSION2}/tools/build/v2/user-config.jam
	cd boost_${BOOST_VERSION2} && \
	./bjam -j16 --build-dir=boost-build --stagedir=boost-stage --prefix=${PREFIX} toolset=darwin architecture=arm target-os=iphone macosx-version=iphone-${IPHONE_SDKVERSION} define=_LITTLE_ENDIAN link=static stage && \
	./bjam -j16 --build-dir=boost-build --stagedir=boost-stage --prefix=${PREFIX} toolset=darwin architecture=arm target-os=iphone macosx-version=iphone-${IPHONE_SDKVERSION} define=_LITTLE_ENDIAN link=static install

## Boost -arch ${ARCH} -miphoneos-version-min=6.1 -std=c++11 -stdlib=libc++
#${LIBDIR}/libboost_system.a: ${LIBDIR}/libicuuc.a
#		rm -rf boost-build boost-stage
#		cd boost && ./bootstrap.sh --with-libraries=thread,signals,filesystem,regex,system,date_time,program_options
#		cd boost && git checkout tools/build/v2/user-config.jam
#		echo "using darwin : iphone \n \
#				: ${CXX} -miphoneos-version-min=6.1 -fvisibility=hidden -fvisibility-inlines-hidden ${CXXFLAGS} -I${INCLUDEDIR} -L${LIBDIR} \n \
#				: <architecture>arm <target-os>iphone \n \
#				;" >> boost/tools/build/v2/user-config.jam
#		cd boost && ./bjam -a --build-dir=boost-build --stagedir=boost-stage --prefix=${PREFIX} toolset=darwin architecture=arm target-os=iphone  define=_LITTLE_ENDIAN link=static install

${LIBDIR}/libfreetype.a:
	cd freetype2 && ./autogen.sh && \
	./configure --without-zlib --without-png --without-bzip2 '--prefix=${PREFIX}' '--host=arm-apple-darwin' '--enable-static=yes' '--enable-shared=no' 'CC=${CC}' 'CFLAGS=-arch ${ARCH} -pipe -std=c99 -Wno-trigraphs -fpascal-strings -O2 -Wreturn-type -Wunused-variable -fmessage-length=0 -fvisibility=hidden -miphoneos-version-min=6.1 -I${IOS_SDK}/usr/include/libxml2/ -isysroot ${IOS_SDK}/' 'AR=${AR}' 'LDFLAGS=-arch ${ARCH} -isysroot ${IOS_SDK}/ -miphoneos-version-min=6.1' \
	&& ${MAKE} clean && ${MAKE} && ${MAKE} install
	#&& make clean && make && make install

#./configure --without-zlib --without-png --without-bzip2 '--prefix=/usr/local/iPhone'                               '--host=arm-apple-darwin' '--enable-static=yes' '--enable-shared=no' 'CC=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' 'CFLAGS=-arch armv7 -pipe -std=c99 -Wno-trigraphs -fpascal-strings -O2 -Wreturn-type -Wunused-variable -fmessage-length=0 -fvisibility=hidden -miphoneos-version-min=6.1 -I/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk/usr/include/libxml2/ -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk/' 'AR=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/ar' 'LDFLAGS=-arch armv7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk/ -miphoneos-version-min=6.1'

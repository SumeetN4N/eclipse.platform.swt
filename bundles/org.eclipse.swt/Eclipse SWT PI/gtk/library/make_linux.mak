#*******************************************************************************
# Copyright (c) 2000, 2016 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#     IBM Corporation - initial API and implementation
#*******************************************************************************

# Makefile for creating SWT libraries for Linux GTK

# SWT debug flags for various SWT components.
#SWT_WEBKIT_DEBUG = -DWEBKIT_DEBUG
#SWT_LIB_DEBUG=1     # to debug glue code in /bundles/org.eclipse.swt/bin/library. E.g os_custom.c:swt_fixed_forall(..)

ifdef SWT_LIB_DEBUG
SWT_DEBUG = -O0 -g3 -ggdb3
NO_STRIP=1
endif

include make_common.mak

SWT_VERSION=$(maj_ver)$(min_ver)
GTK_VERSION?=2.0

# Define the various shared libraries to be build.
WS_PREFIX = gtk
SWT_PREFIX = swt
AWT_PREFIX = swt-awt
ifeq ($(GTK_VERSION), 3.0)
SWTPI_PREFIX = swt-pi3
else
SWTPI_PREFIX = swt-pi
endif
CAIRO_PREFIX = swt-cairo
ATK_PREFIX = swt-atk
MOZILLA_PREFIX = swt-mozilla$(GCC_VERSION)
XULRUNNER_PREFIX = swt-xulrunner
XPCOMINIT_PREFIX = swt-xpcominit
WEBKIT_PREFIX = swt-webkit
GLX_PREFIX = swt-glx

SWT_LIB = lib$(SWT_PREFIX)-$(WS_PREFIX)-$(SWT_VERSION).so
AWT_LIB = lib$(AWT_PREFIX)-$(WS_PREFIX)-$(SWT_VERSION).so
SWTPI_LIB = lib$(SWTPI_PREFIX)-$(WS_PREFIX)-$(SWT_VERSION).so
CAIRO_LIB = lib$(CAIRO_PREFIX)-$(WS_PREFIX)-$(SWT_VERSION).so
ATK_LIB = lib$(ATK_PREFIX)-$(WS_PREFIX)-$(SWT_VERSION).so
MOZILLA_LIB = lib$(MOZILLA_PREFIX)-$(WS_PREFIX)-$(SWT_VERSION).so
XULRUNNER_LIB = lib$(XULRUNNER_PREFIX)-$(WS_PREFIX)-$(SWT_VERSION).so
XPCOMINIT_LIB = lib$(XPCOMINIT_PREFIX)-$(WS_PREFIX)-$(SWT_VERSION).so
WEBKIT_LIB = lib$(WEBKIT_PREFIX)-$(WS_PREFIX)-$(SWT_VERSION).so
GLX_LIB = lib$(GLX_PREFIX)-$(WS_PREFIX)-$(SWT_VERSION).so

CAIROCFLAGS = `pkg-config --cflags cairo`
CAIROLIBS = `pkg-config --libs-only-L cairo` -lcairo

# Do not use pkg-config to get libs because it includes unnecessary dependencies (i.e. pangoxft-1.0)
GTKCFLAGS = `pkg-config --cflags gtk+-$(GTK_VERSION) gtk+-unix-print-$(GTK_VERSION)`
ifeq ($(GTK_VERSION), 3.0)
GTKLIBS = `pkg-config --libs-only-L gtk+-$(GTK_VERSION) gthread-2.0` $(XLIB64) -L/usr/X11R6/lib -lgtk-3 -lgdk-3 -lcairo -lgthread-2.0 -lXtst
else
GTKLIBS = `pkg-config --libs-only-L gtk+-$(GTK_VERSION) gthread-2.0` $(XLIB64) -L/usr/X11R6/lib -lgtk-x11-$(GTK_VERSION) -lgthread-2.0 -lXtst
endif

AWT_LFLAGS = -shared ${SWT_LFLAGS} 
AWT_LIBS = -L$(AWT_LIB_PATH) -ljawt

ATKCFLAGS = `pkg-config --cflags atk gtk+-$(GTK_VERSION) gtk+-unix-print-$(GTK_VERSION)`
ATKLIBS = `pkg-config --libs-only-L atk` -latk-1.0 

GLXLIBS = -lGL -lGLU -lm

# Uncomment for Native Stats tool
#NATIVE_STATS = -DNATIVE_STATS

MOZILLACFLAGS = -O \
	-DSWT_VERSION=$(SWT_VERSION) \
	$(NATIVE_STATS) \
	-DMOZILLA_STRICT_API=1 \
	-fno-rtti \
	-fno-exceptions \
	-Wall \
	-Wno-non-virtual-dtor \
	-fPIC \
	-I. \
	-I$(JAVA_HOME)/include \
	-I$(JAVA_HOME)/include/linux \
	${SWT_PTR_CFLAGS}
MOZILLALFLAGS = -shared ${SWT_LFLAGS} -Wl,--version-script=mozilla_exports -Bsymbolic
MOZILLAEXCLUDES = -DNO__1XPCOMGlueShutdown \
	-DNO__1XPCOMGlueStartup \
	-DNO__1XPCOMGlueLoadXULFunctions \
	-DNO_memmove__ILorg_eclipse_swt_internal_mozilla_nsDynamicFunctionLoad_2I \
	-DNO_memmove__JLorg_eclipse_swt_internal_mozilla_nsDynamicFunctionLoad_2J \
	-DNO_nsDynamicFunctionLoad_1sizeof \
	-DNO__1Call__IIIIII \
	-DNO__1Call__JJJJJI \
	-DNO_nsDynamicFunctionLoad
XULRUNNEREXCLUDES = -DNO__1NS_1InitXPCOM2


WEBKITLIBS = `pkg-config --libs-only-l gio-2.0`
WEBKITCFLAGS = `pkg-config --cflags gio-2.0`
ifdef SWT_WEBKIT_DEBUG
# don't use 'webkit2gtk-4.0' in production,  as some systems might not have those libs and we get crashes.
WEBKITLIBS +=  `pkg-config --libs-only-l webkit2gtk-4.0`
WEBKITCFLAGS +=  `pkg-config --cflags webkit2gtk-4.0`
endif


SWT_OBJECTS = swt.o c.o c_stats.o callback.o
AWT_OBJECTS = swt_awt.o
SWTPI_OBJECTS = swt.o os.o os_structs.o os_custom.o os_stats.o
CAIRO_OBJECTS = swt.o cairo.o cairo_structs.o cairo_stats.o
ATK_OBJECTS = swt.o atk.o atk_structs.o atk_custom.o atk_stats.o
MOZILLA_OBJECTS = swt.o xpcom.o xpcom_custom.o xpcom_structs.o xpcom_stats.o
XULRUNNER_OBJECTS = swt.o xpcomxul.o xpcomxul_custom.o xpcomxul_structs.o xpcomxul_stats.o
XPCOMINIT_OBJECTS = swt.o xpcominit.o xpcominit_structs.o xpcominit_stats.o
WEBKIT_OBJECTS = swt.o webkitgtk.o webkitgtk_structs.o webkitgtk_stats.o webkitgtk_custom.o
GLX_OBJECTS = swt.o glx.o glx_structs.o glx_stats.o

CFLAGS = -O -Wall \
		-DSWT_VERSION=$(SWT_VERSION) \
		$(NATIVE_STATS) \
		$(SWT_DEBUG) \
		$(SWT_WEBKIT_DEBUG) \
		-DLINUX -DGTK \
		-I$(JAVA_HOME)/include \
		-I$(JAVA_HOME)/include/linux \
		-fPIC \
		${SWT_PTR_CFLAGS}
LFLAGS = -shared -fPIC ${SWT_LFLAGS}

ifndef NO_STRIP
	# -s = Remove all symbol table and relocation information from the executable.
	#      i.e, more efficent code, but removes debug information. Should not be used if you want to debug.
	#      https://gcc.gnu.org/onlinedocs/gcc/Link-Options.html#Link-Options
	#      http://stackoverflow.com/questions/14175040/effects-of-removing-all-symbol-table-and-relocation-information-from-an-executab
	AWT_LFLAGS := $(AWT_LFLAGS) -s
	MOZILLALFLAGS := $(MOZILLALFLAGS) -s
	LFLAGS := $(LFLAGS) -s
endif

all: make_swt make_atk make_glx make_webkit

#
# SWT libs
#
make_swt: $(SWT_LIB) $(SWTPI_LIB)

$(SWT_LIB): $(SWT_OBJECTS)
	$(CC) $(LFLAGS) -o $(SWT_LIB) $(SWT_OBJECTS)

callback.o: callback.c callback.h
	$(CC) $(CFLAGS) -DUSE_ASSEMBLER -c callback.c

$(SWTPI_LIB): $(SWTPI_OBJECTS)
	$(CC) $(LFLAGS) -o $(SWTPI_LIB) $(SWTPI_OBJECTS) $(GTKLIBS)

swt.o: swt.c swt.h
	$(CC) $(CFLAGS) -c swt.c
os.o: os.c os.h swt.h os_custom.h
	$(CC) $(CFLAGS) $(GTKCFLAGS) -c os.c
os_structs.o: os_structs.c os_structs.h os.h swt.h
	$(CC) $(CFLAGS) $(GTKCFLAGS) -c os_structs.c 
os_custom.o: os_custom.c os_structs.h os.h swt.h
	$(CC) $(CFLAGS) $(GTKCFLAGS) -c os_custom.c
os_stats.o: os_stats.c os_structs.h os.h os_stats.h swt.h
	$(CC) $(CFLAGS) $(GTKCFLAGS) -c os_stats.c

#
# CAIRO libs
#
make_cairo: $(CAIRO_LIB)

$(CAIRO_LIB): $(CAIRO_OBJECTS)
	$(CC) $(LFLAGS) -o $(CAIRO_LIB) $(CAIRO_OBJECTS) $(CAIROLIBS)

cairo.o: cairo.c cairo.h swt.h
	$(CC) $(CFLAGS) $(CAIROCFLAGS) -c cairo.c
cairo_structs.o: cairo_structs.c cairo_structs.h cairo.h swt.h
	$(CC) $(CFLAGS) $(CAIROCFLAGS) -c cairo_structs.c
cairo_stats.o: cairo_stats.c cairo_structs.h cairo.h cairo_stats.h swt.h
	$(CC) $(CFLAGS) $(CAIROCFLAGS) -c cairo_stats.c

#
# AWT lib
#
make_awt:$(AWT_LIB)

$(AWT_LIB): $(AWT_OBJECTS)
	$(CC) $(AWT_LFLAGS) -o $(AWT_LIB) $(AWT_OBJECTS) $(AWT_LIBS)

#
# Atk lib
#
make_atk: $(ATK_LIB)

$(ATK_LIB): $(ATK_OBJECTS)
	$(CC) $(LFLAGS) -o $(ATK_LIB) $(ATK_OBJECTS) $(ATKLIBS)

atk.o: atk.c atk.h
	$(CC) $(CFLAGS) $(ATKCFLAGS) -c atk.c
atk_structs.o: atk_structs.c atk_structs.h atk.h
	$(CC) $(CFLAGS) $(ATKCFLAGS) -c atk_structs.c
atk_custom.o: atk_custom.c atk_structs.h atk.h
	$(CC) $(CFLAGS) $(ATKCFLAGS) -c atk_custom.c
atk_stats.o: atk_stats.c atk_structs.h atk_stats.h atk.h
	$(CC) $(CFLAGS) $(ATKCFLAGS) -c atk_stats.c

#
# Mozilla lib
#
make_mozilla:$(MOZILLA_LIB)

$(MOZILLA_LIB): $(MOZILLA_OBJECTS)
	$(CXX) -o $(MOZILLA_LIB) $(MOZILLA_OBJECTS) $(MOZILLALFLAGS) ${MOZILLA_LIBS}

xpcom.o: xpcom.cpp
	$(CXX) $(MOZILLACFLAGS) $(MOZILLAEXCLUDES) ${MOZILLA_INCLUDES} -c xpcom.cpp

xpcom_structs.o: xpcom_structs.cpp
	$(CXX) $(MOZILLACFLAGS) $(MOZILLAEXCLUDES) ${MOZILLA_INCLUDES} -c xpcom_structs.cpp
	
xpcom_custom.o: xpcom_custom.cpp
	$(CXX) $(MOZILLACFLAGS) $(MOZILLAEXCLUDES) ${MOZILLA_INCLUDES} -c xpcom_custom.cpp

xpcom_stats.o: xpcom_stats.cpp
	$(CXX) $(MOZILLACFLAGS) $(MOZILLAEXCLUDES) ${MOZILLA_INCLUDES} -c xpcom_stats.cpp

#
# XULRunner libs
#
make_xulrunner:$(XULRUNNER_LIB)

$(XULRUNNER_LIB): $(XULRUNNER_OBJECTS)
	$(CXX) -o $(XULRUNNER_LIB) $(XULRUNNER_OBJECTS) $(MOZILLALFLAGS) ${XULRUNNER_LIBS}

xpcomxul.o: xpcom.cpp
	$(CXX) -o xpcomxul.o $(MOZILLACFLAGS) $(XULRUNNEREXCLUDES) ${XULRUNNER_INCLUDES} -c xpcom.cpp

xpcomxul_structs.o: xpcom_structs.cpp
	$(CXX) -o xpcomxul_structs.o $(MOZILLACFLAGS) $(XULRUNNEREXCLUDES) ${XULRUNNER_INCLUDES} -c xpcom_structs.cpp
	
xpcomxul_custom.o: xpcom_custom.cpp
	$(CXX) -o xpcomxul_custom.o $(MOZILLACFLAGS) $(XULRUNNEREXCLUDES) ${XULRUNNER_INCLUDES} -c xpcom_custom.cpp

xpcomxul_stats.o: xpcom_stats.cpp
	$(CXX) -o xpcomxul_stats.o $(MOZILLACFLAGS) $(XULRUNNEREXCLUDES) ${XULRUNNER_INCLUDES} -c xpcom_stats.cpp

#
# libswt-xulrunner-fix10.so and libswt-xulrunner-fix31.so are not built each time, they have been built and committed to the repository
# make_xulrunner_fix:
#	echo -e "#include<stdlib.h>\nsize_t je_malloc_usable_size_in_advance(size_t n) {\nreturn n;\n}" | $(CXX) $(LFLAGS) $(CFLAGS) -xc - -o libswt-xulrunner-fix10.so
#	echo -e "#include<stdlib.h>\nsize_t je_malloc_usable_size_in_advance(size_t n) {\nreturn n;\n}" | $(CXX) $(LFLAGS) $(CFLAGS) -L${XULRUNNER31_SDK}/lib -Wl,--whole-archive -lmozglue -Wl,--no-whole-archive -xc - -o libswt-xulrunner-fix31.so
#

#
# XPCOMInit lib
#
make_xpcominit:$(XPCOMINIT_LIB)

$(XPCOMINIT_LIB): $(XPCOMINIT_OBJECTS)
	$(CXX) -o $(XPCOMINIT_LIB) $(XPCOMINIT_OBJECTS) $(MOZILLALFLAGS) ${XULRUNNER_LIBS}

xpcominit.o: xpcominit.cpp
	$(CXX) $(MOZILLACFLAGS) ${XULRUNNER_INCLUDES} -c xpcominit.cpp

xpcominit_structs.o: xpcominit_structs.cpp
	$(CXX) $(MOZILLACFLAGS) ${XULRUNNER_INCLUDES} -c xpcominit_structs.cpp
	
xpcominit_stats.o: xpcominit_stats.cpp
	$(CXX) $(MOZILLACFLAGS) ${XULRUNNER_INCLUDES} -c xpcominit_stats.cpp

#
# WebKit lib
#
make_webkit: $(WEBKIT_LIB)

$(WEBKIT_LIB): $(WEBKIT_OBJECTS)
	$(CC) $(LFLAGS) -o $(WEBKIT_LIB) $(WEBKIT_OBJECTS) $(WEBKITLIBS)

webkitgtk.o: webkitgtk.c webkitgtk_custom.h
	$(CC) $(CFLAGS) $(WEBKITCFLAGS) -c webkitgtk.c

webkitgtk_structs.o: webkitgtk_structs.c
	$(CC) $(CFLAGS) $(WEBKITCFLAGS) -c webkitgtk_structs.c

webkitgtk_stats.o: webkitgtk_stats.c webkitgtk_stats.h
	$(CC) $(CFLAGS) $(WEBKITCFLAGS) -c webkitgtk_stats.c

webkitgtk_custom.o: webkitgtk_custom.c
	$(CC) $(CFLAGS) $(WEBKITCFLAGS) -c webkitgtk_custom.c

#
# GLX lib
#
make_glx: $(GLX_LIB)

$(GLX_LIB): $(GLX_OBJECTS)
	$(CC) $(LFLAGS) -o $(GLX_LIB) $(GLX_OBJECTS) $(GLXLIBS)

glx.o: glx.c 
	$(CC) $(CFLAGS) $(GLXCFLAGS) -c glx.c

glx_structs.o: glx_structs.c 
	$(CC) $(CFLAGS) $(GLXCFLAGS) -c glx_structs.c
	
glx_stats.o: glx_stats.c glx_stats.h
	$(CC) $(CFLAGS) $(GLXCFLAGS) -c glx_stats.c

#
# Install
#
install: all
	cp *.so $(OUTPUT_DIR)

#
# Clean
#
clean:
	rm -f *.o *.so

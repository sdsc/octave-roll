# $Id$
#
# @Copyright@
#
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 7.0 (Manzanita)
#
# Copyright (c) 2000 - 2017 The Regents of the University of California.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice unmodified and in its entirety, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided
# with the distribution.
#
# 3. All advertising and press materials, printed or electronic, mentioning
# features or use of this software must display the following acknowledgement:
#
# 	"This product includes software developed by the Rocks(r)
# 	Cluster Group at the San Diego Supercomputer Center at the
# 	University of California, San Diego and its contributors."
#
# 4. Except as permitted for the purposes of acknowledgment in paragraph 3,
# neither the name or logo of this software nor the names of its
# authors may be used to endorse or promote products derived from this
# software without specific prior written permission.  The name of the
# software includes the following terms, and any derivatives thereof:
# "Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of
# the associated name, interested parties should contact Technology
# Transfer & Intellectual Property Services, University of California,
# San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910,
# Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# @Copyright@
#
# $Log$

REDHAT.ROOT = $(CURDIR)/../../
RPM.EXTRAS=%define __os_install_post /usr/lib/rpm/brp-compress

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

COMPILER_FLAGS = -O2 -fopenmp
EXTRA_CONFIGURE_OPTION =

MKLLINK = -Wl,-rpath,$${MKLLIB} -L$${MKLLIB} -lmkl_gf_ilp64 \
          -lmkl_gnu_thread -lmkl_core -ldl -lpthread -lm
ifeq ("$(COMPILERNAME)", "intel")
  EXTRA_CONFIGURE_OPTION = --enable-fortran-calling-convention=f2c
  MKLLINK = -mkl
endif

# The Intel compilers use the C++ libraries that are packaged with the first
# gnu compiler found in PATH. Since the default system gnu doesn't support
# C++11, for Intel we have to load /opt/gnu to get the updated library.
MODULE_LOAD_CXX11_LIB = $(call MODULE_LOAD_COMPILER, gnu, gcc)

ifneq ("$(ROLLOPTS)", "$(subst avx,,$(ROLLOPTS))")
  ifeq ("$(COMPILERNAME)", "gnu")
    ifneq ("$(ROLLOPTS)", "$(subst avx2,,$(ROLLOPTS))")
      COMPILER_FLAGS += -mavx2
    else
      COMPILER_FLAGS += -mavx
    endif
  else ifeq ("$(COMPILERNAME)", "intel")
    ifneq ("$(ROLLOPTS)", "$(subst avx2,,$(ROLLOPTS))")
      COMPILER_FLAGS += -mtune=core-avx2
    else
      COMPILER_FLAGS += -mtune=core-avx-i
    endif
  endif
endif

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MPI); \
	  $(DESCRIBE_FFTW); \
	  $(DESCRIBE_HDF5) \
	) > $@
	$(MODULE_LOAD_MKL); \
	if test -n "$${MKLHOME}"; then \
	  $(DESCRIBE_MKL) >> $@; \
	fi

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo GPLv3+ > $@

build: $(SRC_DIRS)
	( \
	  if test "$(COMPILERNAME)" = "intel"; then \
	    $(MODULE_LOAD_CXX11_LIB); \
	  fi; \
	  $(MODULE_LOAD_CC); \
          $(MODULE_LOAD_MPI); \
	  $(MODULE_LOAD_FFTW); \
	  $(MODULE_LOAD_HDF5); \
	  $(MODULE_LOAD_MKL); \
	  export CC=mpicc; \
	  export CFLAGS="$(COMPILER_FLAGS)"; \
	  export CXX=mpicxx; \
	  export CXXFLAGS="$(COMPILER_FLAGS)"; \
	  export F77=mpif90; \
	  export FFLAGS="$(COMPILER_FLAGS)"; \
	  cd $(SOURCE_DIR); \
	  mkdir build; \
	  cd build; \
          export CPPFLAGS="-I$${MPIHOME}/include -I/share/apps/compute/pcre/include"; \
          export LDFLAGS="-L/share/apps/compute/pcre/lib"; \
	  if test -n "$${MKLHOME}"; then \
	    if test "$(COMPILERNAME)" = "intel"; then \
	      export F77_INTEGER_8_FLAG=-i8; \
	    elif test "$(COMPILERNAME)" = "gnu"; then \
	      export F77_INTEGER_8_FLAG=-fdefault-integer-8; \
	    fi; \
	    export CFLAGS="$${CFLAGS} -I$${MKLHOME}/include -m64"; \
	    export CXXFLAGS="$${CXXFLAGS} -I$${MKLHOME}/include -m64"; \
	    export FFLAGS="$${FFLAGS} -I$${MKLHOME}/include -m64"; \
	    export MKLLIB=$${MKLHOME}/lib/intel64; \
	    ../configure --prefix=$(PKGROOT)  --with-qt=5 \
	      --with-fftw3-includedir=$${FFTWHOME}/include --with-fftw3-libdir=$${FFTWHOME}/lib \
	      --with-fftw3f-includedir=$${FFTWHOME}/include --with-fftw3f-libdir=$${FFTWHOME}/lib \
	      --with-hdf5-includedir=$${HDF5HOME}/include --with-hdf5-libdir=$${HDF5HOME}/lib \
	      --with-blas="$(MKLLINK)" --with-lapack="$(MKLLINK)" --enable-64 \
              $(EXTRA_CONFIGURE_OPTION); \
	  else \
	    ../configure --prefix=$(PKGROOT)  --with-qt=5 \
	      --with-fftw3-includedir=$${FFTWHOME}/include --with-fftw3-libdir=$${FFTWHOME}/lib \
	      --with-fftw3f-includedir=$${FFTWHOME}/include --with-fftw3f-libdir=$${FFTWHOME}/lib \
	      --with-hdf5-includedir=$${HDF5HOME}/include --with-hdf5-libdir=$${HDF5HOME}/lib \
              $(EXTRA_CONFIGURE_OPTION); \
	  fi \
	)
	@echo "::: Package $(NAME) build complete :::"
	
install::
	# Using a bind mount appears to be the only way to prevent the build
	# from incorporating $(ROOT) in binary files.
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	$(PKGROOT_BIND_MOUNT)
	( \
	  if test "$(COMPILERNAME)" = "intel"; then \
	    $(MODULE_LOAD_CXX11_LIB); \
	  fi; \
	  $(MODULE_LOAD_CC); \
          $(MODULE_LOAD_MPI); \
	  $(MODULE_LOAD_FFTW); \
	  $(MODULE_LOAD_HDF5); \
	  $(MODULE_LOAD_MKL); \
	  export CC=mpicc; \
	  export CFLAGS="$(COMPILER_FLAGS)"; \
          export CXX=mpicxx; \
          export CXXFLAGS="$(COMPILER_FLAGS)"; \
          export F77=mpif90; \
          export FFLAGS="$(COMPILER_FLAGS)"; \
          cd $(SOURCE_DIR)/build; \
          $(MAKE) -j `nproc --ignore=2` install; \
          export LD_LIBRARY_PATH=$(PKGROOT)/lib/octave/$(VERSION):$${LD_LIBRARY_PATH}; \
          export CXXFLAGS=-std=c++11; \
          cd ../..; \
          $(PKGROOT)/bin/octave --eval "pkg install -global $(STRUCT_PKG)"; \
          $(PKGROOT)/bin/octave --eval "pkg install -global $(PARALLEL_PKG)"; \
          $(PKGROOT)/bin/octave --eval "pkg install -global $(CONTROL_PKG)"; \
          $(PKGROOT)/bin/octave --eval "pkg install -global $(SIGNAL_PKG)" \
        )
	$(PKGROOT_BIND_UMOUNT)
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) $(PARALLEL_DIR) DESCRIPTION LICENSE

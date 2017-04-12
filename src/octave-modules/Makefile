REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Rules.mk

$(VERSION_INC): $(VERSION_SRC)
	/bin/grep 'VERSION.*=' $(VERSION_SRC) > $@
 
build:

install:: typical-modulefile-install
	  $(MODULE_LOAD_MKL); \
	  rollmkl=; \
	  if test -n "$${MKL_ROOT}"; then \
	    rollmkl=mkl; \
	  fi; \
	  perl -pi -e "s/ROLLMKL/$$rollmkl/" $(ROOT)/$(PKGROOT)/$(VERSION)

clean::
	rm -f $(VERSION_INC)

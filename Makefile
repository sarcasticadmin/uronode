all: nodeusers uronode axdigi flexd

CC = gcc
LD = gcc
CFLAGS = -static -Wstrict-prototypes -O2 -g
LDFLAGS = -static
LIBS = -lax25 -lax25io

include Makefile.include

COMMON_SRC =		user.c util.c
NODE_SRC =		node.c cmdparse.c config.c command.c mheard.c axcalluser.c \
			gateway.c extcmd.c procinfo.c router.c system.c sysinfo.c ipc.c
NODEUSERS_SRC =		nodeusers.c
FLEXD_SRC = 		flexd.c procinfo.c
DIGI_SRC =		axdigi.c

COMMON_OBJS =		$(COMMON_SRC:.c=.o)
NODE_OBJS =		$(NODE_SRC:.c=.o)
NODEUSERS_OBJS =	$(NODEUSERS_SRC:.c=.o)
FLEXD_OBJS =		$(FLEXD_SRC:.c=.o)
DIGI_OBJS =		$(DIGI_SRC:.c=.o)
.c.o:
	$(CC) $(CFLAGS) -c $<

install: installbin installman installhelp installconf
	install -m 755    -D -d	$(VAR_DIR)
	install -m 755    -D -d	$(VAR_DIR)/node
	install -m 644    -p etc/loggedin	$(VAR_DIR)/node
	install -m 644    -p etc/lastlog	$(VAR_DIR)/node
	install -m 755    -D -d	$(VAR_DIR)/flex
	install -m 644    -p etc/gateways	 $(VAR_DIR)/flex
	
installbin: all
	install -m 755 	-s -p	calibrate	$(SBIN_DIR)
	install -m 755 	-s -p	uronode		$(SBIN_DIR)
	install -m 755  -s -p	nodeusers	$(SBIN_DIR)
	install -m 755  -s -p	axdigi		$(SBIN_DIR)
	install -m 755  -s -p	flexd		$(SBIN_DIR)

installhelp:
	install -m 755    -D -d		 $(VAR_DIR)
	install -m 755    -D -d		 $(VAR_DIR)/node/help
	install -m 644    -p etc/help/*.hlp $(VAR_DIR)/node/help

installconf: installhelp
	install -m 755    -D -d		 $(ETC_DIR)
	install -m 600    -p etc/uronode.conf  $(ETC_DIR)
	install -m 600    -p etc/uronode.perms $(ETC_DIR)
	install -m 600    -p etc/uronode.info  $(ETC_DIR)
	install -m 600    -p etc/uronode.motd  $(ETC_DIR)
	install -m 600    -p etc/uronode.users $(ETC_DIR)
	install -m 600    -p etc/uronode.routes   $(ETC_DIR)
	install -m 600    -p etc/flexd.conf  $(ETC_DIR)

installman:
	install -m 755	  -D -d $(MAN_DIR)/man1 $(MAN_DIR)/man5 $(MAN_DIR)/man8
	install -m 644    -p man/nodeusers.1.gz  $(MAN_DIR)/man1
	install -m 644    -p man/uronode.conf.5.gz  $(MAN_DIR)/man5
	install -m 644    -p man/uronode.perms.5.gz $(MAN_DIR)/man5
	install -m 644    -p man/flexd.conf.5.gz $(MAN_DIR)/man5
	install -m 644    -p man/uronode.8.gz       $(MAN_DIR)/man8
	install -m 644	  -p man/axdigi.8.gz	 $(MAN_DIR)/man8

upgrade: installman
	install -m 755 -p calibrate     $(SBIN_DIR)
	install -m 755 -p uronode       $(SBIN_DIR)
	install -m 755 -p nodeusers     $(SBIN_DIR)
	install -m 755 -p flexd		$(SBIN_DIR)
	install -m 755 -p axdigi	$(SBIN_DIR)
	install -m 644 -p uronode.conf	$(ETC_DIR)
	install -m 644 -p uronode.perms $(ETC_DIR)
 
clean:
	rm -f *.o *~ *.bak *.orig make.debug nodeusers uronode flexd axdigi
	rm -f etc/*~ etc/*.bak etc/*.orig
	rm -f etc/help/*~ etc/help/*.bak etc/help/*.orig

distclean: clean
	rm -f .depend Makefile.include config.h
	rm -f uronode nodeusers axdigi flexd
	rm -f Makefile make.debug

depend:
	$(CC) $(CFLAGS) -M $(COMMON_SRC) $(NODE_SRC) $(NODEUSERS_SRC) $(FLEXD_SRC) > .depend

uronode: $(COMMON_OBJS) $(NODE_OBJS)
	$(LD) $(LDFLAGS) -o uronode $(COMMON_OBJS) $(NODE_OBJS) $(LIBS) $(ZLIB)

nodeusers: $(COMMON_OBJS) $(NODEUSERS_OBJS)
	$(LD) $(LDFLAGS) -o nodeusers $(COMMON_OBJS) $(NODEUSERS_OBJS) $(LIBS) $(ZLIB)

flexd: $(FLEXD_OBJS)
	$(LD) $(LDFLAGS) -o flexd $(FLEXD_OBJS) $(LIBS) $(ZLIB)

axdigi: $(DIGI_OBJS)
	$(LD) $(LDFLAGS) -o axdigi $(DIGI_OBJS) 

ifeq (.depend,$(wildcard .depend))
include .depend
endif
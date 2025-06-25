SHELL=/bin/bash

ETCDIR=/etc
LIBDIR=${DESTDIR}/lib/services
EXTDIR=${DESTDIR}${ETCDIR}
MODE=754
DIRMODE=755
CONFMODE=644

all:
	@grep "^install" Makefile | cut -d ":" -f 1
	@echo "Select an appropriate install target from the above list"

create-dirs:
	install -d -m ${DIRMODE} ${EXTDIR}/rc.d/rc{0,1,2,3,4,5,6,S}.d
	install -d -m ${DIRMODE} ${EXTDIR}/rc.d/init.d
	install -d -m ${DIRMODE} ${EXTDIR}/sysconfig

create-service-dir:
	install -d -m ${DIRMODE} ${LIBDIR}

install-nvidia-powerd:
	install -m755 nvidia-sleep /usr/bin
	install -m ${MODE} nvidia-powerd ${EXTDIR}/rc.d/init.d/
	ln -sf  ../init.d/nvidia-powerd ${EXTDIR}/rc.d/rc0.d/K22nvidia-powerd
	ln -sf  ../init.d/nvidia-powerd ${EXTDIR}/rc.d/rc1.d/K22nvidia-powerd
	ln -sf  ../init.d/nvidia-powerd ${EXTDIR}/rc.d/rc2.d/S36nvidia-powerd
	ln -sf  ../init.d/nvidia-powerd ${EXTDIR}/rc.d/rc3.d/S36nvidia-powerd
	ln -sf  ../init.d/nvidia-powerd ${EXTDIR}/rc.d/rc4.d/S36nvidia-powerd
	ln -sf  ../init.d/nvidia-powerd ${EXTDIR}/rc.d/rc5.d/S36nvidia-powerd
	ln -sf  ../init.d/nvidia-powerd ${EXTDIR}/rc.d/rc6.d/K22nvidia-powerd

uninstall-nvidia-powerd:
	rm -f /usr/bin/nvidia-sleep
	rm -f ${EXTDIR}/rc.d/init.d/nvidia-powerd
	rm -f ${EXTDIR}/rc.d/rc0.d/K22nvidia-powerd
	rm -f ${EXTDIR}/rc.d/rc1.d/K22nvidia-powerd
	rm -f ${EXTDIR}/rc.d/rc2.d/S36nvidia-powerd
	rm -f ${EXTDIR}/rc.d/rc3.d/S36nvidia-powerd
	rm -f ${EXTDIR}/rc.d/rc4.d/S36nvidia-powerd
	rm -f ${EXTDIR}/rc.d/rc5.d/S36nvidia-powerd
	rm -f ${EXTDIR}/rc.d/rc6.d/K22nvidia-powerd

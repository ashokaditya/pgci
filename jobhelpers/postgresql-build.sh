./configure --enable-debug --enable-depend --enable-cassert --with-tcl --with-perl --with-python --with-krb5 --with-pam --with-ldap --with-openssl --with-libxml --with-libxslt --with-gssapi --enable-thread-safety --enable-nls --with-ossp-uuid --disable-rpath

if grep -qw world GNUmakefile; then
	make -k world
else
	make -k all
	make -k -C contrib all
	make -k -C doc/src/sgml all
fi

if grep -qw maintainer-check GNUmakefile; then
	make -k maintainer-check
fi

if grep -qw check-world GNUmakefile; then
	make -k check-world || echo unstable | md5sum
else
	make -k check || echo unstable | md5sum
fi

majorversion=$(./configure --version | sed -n -r '1s/^.* ([0-9]+\.[0-9]+).*$/\1/p')
make install DESTDIR=$PWD/postgresql-$majorversion.bin
tar cJf postgresql-$majorversion.bin.tar.xz postgresql-$majorversion.bin/

#!/bin/bash
for j in `seq 1 $1`; do
  if [ ! -d "/usr/local/postfix$j/sbin/postfix" ]; then

    INSTALL_DIR=/usr/local/postfix$j
    make tidy && \
	make makefiles CCARGS="\
      -DDEF_CONFIG_DIR=\\\"$INSTALL_DIR/etc\\\" \
      -DDEF_COMMAND_DIR=\\\"$INSTALL_DIR/sbin\\\" \
      -DDEF_DAEMON_DIR=\\\"$INSTALL_DIR/libexec\\\" \
      -DDEF_DATA_DIR=\\\"$INSTALL_DIR/var\\\" \
      -DDEF_MAILQ_PATH=\\\"$INSTALL_DIR/bin/mailq\\\" \
      -DDEF_HTML_DIR=\\\"$INSTALL_DIR/html\\\" \
      -DDEF_MANPAGE_DIR=\\\"$INSTALL_DIR/man\\\" \
      -DDEF_NEWALIAS_PATH=\\\"$INSTALL_DIR/bin/newaliases\\\" \
      -DDEF_QUEUE_DIR=\\\"$INSTALL_DIR/var/spool\\\" \
      -DDEF_SENDMAIL_PATH=\\\"$INSTALL_DIR/sbin/sendmail\\\"" && \
	make -j 5 && \
	make upgrade
  fi
done

FROM rockylinux/rockylinux:9

RUN dnf install -y bc ncurses git \
    && dnf clean all \
    && printf '%s\n' \
        '#!/bin/sh -x' \
        'dnf install -y ncurses' \
        'dnf clean all' \
        'cd /opt' \
        'git clone https://github.com/xtalcloud/system-image' \
        'chmod a+x /opt/system-image/template/scripts/*' \
        'cd /opt/system-image/template/scripts/' \
        'exec bash' > /run.sh \
    && chmod a+x /run.sh

ENTRYPOINT /run.sh

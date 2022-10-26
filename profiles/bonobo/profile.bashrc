#!/usr/bin/env bash

case ${CATEGORY}/${PN} in
    sys-apps/busybox)
        # see https://bugs.gentoo.org/454294#c7
        ;;
    *)
        export KBUILD_OUTPUT="/usr/src/linux-obj"
        ;;
esac

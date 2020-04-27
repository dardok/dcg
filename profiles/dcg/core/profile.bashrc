#!/usr/bin/env bash

case ${CATEGORY}/${PN} in
    app-portage/eix)
        export EXTRA_ECONF="--enable-security --enable-new-dialect --enable-strong-optimization"
        ;;
esac

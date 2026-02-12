#!/bin/bash
set -euo pipefail

if command -v dnf >/dev/null 2>&1; then
  PM=dnf
else
  PM=yum
fi

if [ "$PM" = "dnf" ]; then
  dnf -y install 'dnf-command(config-manager)' || true
  if dnf repolist all | awk '{print $1}' | grep -qx 'powertools'; then
    dnf config-manager --set-enabled powertools
  fi
  if dnf repolist all | awk '{print $1}' | grep -qx 'crb'; then
    dnf config-manager --set-enabled crb
  fi
fi

$PM -y install epel-release || true
$PM -y install \
  autoconf automake curl python3 python3-pip \
  libmpc-devel mpfr-devel gmp-devel gawk \
  make gcc gcc-c++ bison flex texinfo gperf libtool patchutils bc \
  zlib-devel expat-devel git ninja-build cmake glib2-devel \
  expect libslirp-devel libzstd-devel ncurses-devel file xz which \
  util-linux findutils diffutils

$PM -y install dtc || $PM -y install device-tree-compiler
$PM -y install python3-pyelftools || pip3 install pyelftools

if ! python3 - <<'PY'
import tomllib  # Python 3.11+
PY
then
  pip3 install tomli
fi

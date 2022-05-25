#!/bin/bash
set -e

patches="$(readlink -f -- $1)"
assets="personal spl"

for d in ${assets}; do
  for project in $(cd ${patches}/patches/${d}; echo *); do
    p="$(tr _ / <<<${project} |sed -e 's;platform/;;g')"
    [ "$p" == build ] && p=build/make
    [ "$p" == vendor/hardware/overlay ] && p=vendor/hardware_overlay
    [ "$p" == vendor/partner/gms ] && p=vendor/partner_gms
    [ "$p" == external/harfbuzz/ng ] && p=external/harfbuzz_ng
    echo
    pushd $p
      git clean -fdx
      git reset --hard
      git am ${patches}/patches/${d}/${project}/0*.patch ||exit
    popd
  done
done

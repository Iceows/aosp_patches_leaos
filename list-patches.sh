#!/bin/bash

# How does this script work?

rootrepo="/media/iceows/Projets/iceows/leaos-aosp"
finalpatches="$rootrepo/aosp_patches_leaos/finalpatches"
reposync="$rootrepo/aosp_patches_leaos/patches/trebledroid"

# clear all
rm -rf $finalpatches
mkdir $finalpatches

# find all folder
for project in $(cd $reposync; echo *);do
	echo "Processing : "$project
	p="$(tr _ / <<<$project |sed -e 's;platform/;;g')"
	[ "$p" == build ] && p=build/make
	[ "$p" == vendor/hardware/overlay ] && p=vendor/hardware_overlay
	[ "$p" == vendor/partner/gms ] && p=vendor/partner_gms
	[ "$p" == external/harfbuzz/ng ] && p=external/harfbuzz_ng
	echo $p
	cd $rootrepo/$p
	lastTag="$(git describe --abbrev=0 --match=android-*)"
	mkdir $finalpatches/$project
	git format-patch $lastTag..HEAD -o $finalpatches/$project	
	echo	
done


# Special case for phh repo : device_phh_treble and vendor_hardware_overlay
# just copy
p=vendor_hardware_overlay
echo $p
cd $reposync/$p
cp * $finalpatches/$p

p=device_phh_treble
echo $p
cd $reposync/$p
cp * $finalpatches/$p

# Special case for relan repo
p=platform_external_exfat
echo $p
cd $reposync/$p
cp * $finalpatches/$p

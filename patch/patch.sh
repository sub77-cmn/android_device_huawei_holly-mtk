build_root=$(pwd) # vendorsetup.sh is sourced by build/envsetup.sh in root of android build tree. Hope that nobody can correctly source it not from root of android tree.
patches_path="$build_root/device/terra/terrapad803/patch/"

. vendor/extra/tools/colors

read -n1 -r -p "Press p to start patching..." key

if [ "$key" = 'p' ]; then
    # Space pressed, do something
    # echo [$key] is empty when SPACE is pressed # uncomment to trace

patchdir="$build_root/frameworks/base" # Start patch1
revertnr=
pulldir=https://github.com/sub77-cmn/android_frameworks_base.git
echo -e ${CL_BLU}"PATCHING $patchdir"${CL_RST}
cd $patchdir
#git revert --no-edit $revertnr
git pull $pulldir
cd $build_root # End patch1

patchdir="$build_root/frameworks/opt/telephony" # Start patch1
revertnr=
pulldir=https://github.com/sub77-cmn/frameworks_opt_telephony.git
echo -e ${CL_BLU}"PATCHING $patchdir"${CL_RST}
cd $patchdir
#git revert --no-edit $revertnr
git pull $pulldir
cd $build_root # End patch1

patchdir="$build_root/external/stlport" # Start patch1
revertnr=
pulldir=https://github.com/sub77-cmn/android_external_stlport.git
echo -e ${CL_BLU}"PATCHING $patchdir"${CL_RST}
cd $patchdir
#git revert --no-edit $revertnr
git pull $pulldir
cd $build_root # End patch1

patchdir="$build_root/frameworks/native" # Start patch1
revertnr=
pulldir=https://github.com/sub77-cmn/android_frameworks_native.git
echo -e ${CL_BLU}"PATCHING $patchdir"${CL_RST}
cd $patchdir
#git revert --no-edit $revertnr
git pull $pulldir
cd $build_root # End patch1

echo -e ""
echo -e ${CL_RED}"Applying patches"${CL_RST}
echo -e ${CL_RST}"----------------"${CL_RST}
pushd "$patches_path" > /dev/null
unset repos
for patch in `find -type f -name '*.patch'|cut -d / -f 2-|sort`; do
	# Strip patch title to get git commit title - git ignore [text] prefixes in beginning of patch title during git am
	title=$(sed -rn "s/Subject: (\[[^]]+] *)*//p" "$patch")
	absolute_patch_path="$patches_path/$patch"
	# Supported both path/to/repo_with_underlines/file.patch and path_to_repo+with+underlines/file.patch (both leads to path/to/repo_with_underlines)
	repo_to_patch="$(if dirname $patch|grep -q /; then dirname $patch; else dirname $patch |tr '_' '/'|tr '+' '_'; fi)"

	echo -e ${CL_BLU}" --> Is $repo_to_patch patched for '$title' ?.. "${CL_RST}

        if [ ! -d $build_root/$repo_to_patch ] ; then
                echo "$repo_to_patch NOT EXIST! Go away and check your manifests. Skipping this patch."
                continue
        fi

	pushd "$build_root/$repo_to_patch" > /dev/null
	if (git log |fgrep -qm1 "$title" ); then
		echo -n Yes
	  commit_hash=$(git log --oneline |fgrep -m1 "$title"|cut -d ' ' -f 1)
	  if [ q"$commit_hash" != "q" ]; then
		  commit_id=$(git format-patch -1 --stdout $commit_hash |git patch-id|cut -d ' ' -f 1)
		  patch_id=$(git patch-id < $absolute_patch_path|cut -d ' ' -f 1)
		  if [ "$commit_id" = "$patch_id" ]; then
			  echo -e ${CL_GRN} ', patch matches'${CL_RST}
		  else
		  echo -e ${CL_RED}"PATCH MISMATCH!: done"${CL_RST}
			  #echo ', PATCH MISMATCH!'
			  sed '0,/^$/d' $absolute_patch_path|head -n -3  > /tmp/patch
			  git show --stat $commit_hash -p --pretty=format:%b > /tmp/commit
			  diff -u /tmp/patch /tmp/commit
			  rm /tmp/patch /tmp/commit
			  echo ' Resetting branch!'
			  git checkout $commit_hash~1
			  git am $absolute_patch_path || git am --abort
		  fi
	else
		echo "Unable to get commit hash for '$title'! Something went wrong!"
		sleep 20
	fi
	else
		echo No
		echo -e ${CL_GRN}"Trying to apply patch $(basename "$patch") to '$repo_to_patch'"${CL_RST}
		if ! git am $absolute_patch_path; then
			echo -e ${CL_RED}"Failed, aborting git am"${CL_RST}
			git am --abort
				echo -e ${CL_RED}"Retry git am -3"${CL_RST}
					if ! git am -3 $absolute_patch_path; then
						echo -e ${CL_RED}"Failed -3, aborting git am"${CL_RST}
						git am --abort
					fi
		fi
	fi
	popd > /dev/null
done
popd > /dev/null
echo -e ${CL_RST}"----------------"${CL_RST}
echo -e ${CL_GRN}"Applying patches: done"${CL_RST}

else
    # Anything else pressed, do whatever else.
    # echo [$key] not empty
    echo -e ${CL_GRN}"Skipped patching"${CL_RST}
fi

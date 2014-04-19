#!/bin/bash	

_runme_main() {

	gl_path=$( haxelib path opengl | grep ^/ )
	if [ "" = "${gl_path}" ] ; then
		haxelib install opengl || return 1;
	fi

	# try again
	gl_path=$( haxelib path opengl | grep ^/ )
	if [ "" = "${gl_path}" ] ; then
		echo teh sux 
		return 1;
	fi

 	# ug.. 64-bit linux may not work :-(

	export DYLD_LIBRARY_PATH=$( find ${gl_path} -name opengl.ndll | rev | cut -f2- -d/ | rev | xargs | tr ' ' ':' ):/Developer/SDKs/MacOS*/usr/lib

	haxe compile.hxml && ./app
}

_runme_main ${*}

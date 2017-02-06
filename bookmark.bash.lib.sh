function init_bm_vars(){
	export bookmark_decision=y;
	export bookmark_path=".";
}
init_bm_vars
function bm(){
	if ! [[ -f ~/.bookmarks ]];then
		touch ~/.bookmarks;
	fi

	if [[ $# -eq 3 ]];then
		if [[ $1 == --create || $1 == -c ]];then
			if [[ -d $3 ]];then
				path=$(realpath $3);
				echo "[$2:$path]">>~/.bookmarks
			else
				echo "path doesn't exist!";
			fi
		elif [[ $1 == --update || $1 == -u ]];then
			bookmark=$2;
			path=$3;
			sed -i 's|\['"$bookmark"':\(.*\)\]|\['"$bookmark"':'"$path"'\]|g' ~/.bookmarks;
		elif [[ $1 == --link || $1 == -ln ]];then
			ln -s `bm --query $2` $3;
		else
			bm --help;
		fi

	elif [[ $# -eq 2 ]];then
		if [[ $1 == --delete || $1 == -d ]];then
			sed -i '/\['"$2"':/d' ~/.bookmarks;
		elif [[ $1 == --query || $1 == -q ]];then
			bookmark=$2
			grep "\[$bookmark:" ~/.bookmarks | sed -e 's|\['"$bookmark"':\(.*\)\]|\1|';
		elif [[ $1 == --open || $1 == "-o" ]];then
			bm_path=$(bm --query $2);
			if [[ -d $bm_path ]];then
				bash -c "xdg-open $bm_path" 2> /dev/null
			else
				echo "bookmark doesn't exist!";
			fi
		elif [[ $1 == --open_as_root || $1 == -or ]];then
			bm_path=$(bm --query $2);
			if [[ -d $bm_path ]];then
				bash -c "sudo xdg-open $bm_path" 2> /dev/null
			else
				echo "bookmark doesn't exist!";
			fi
		else
			bm --help;
		fi

	elif [[ $# -eq 1 ]];then
		if [[ $1 == --help ]];then
			echo 'create new bookmark';
			echo '  bm --create <NAME> <PATH>';
			echo '  bm -c <NAME> <PATH>';
			echo 'update bookmark';
			echo '  bm --update <NAME> <PATH>';
			echo '  bm -u <NAME> <PATH>';
			echo 'link bookmark to PATH';
			echo '  bm --link <NAME> <PATH>';
			echo '  bm -ln <NAME> <PATH>';
			echo 'delete bookmark';
			echo '  bm --delete <NAME>';
			echo '  bm -d <NAME>';
			echo 'delete bookmark';
			echo '  bm --query <NAME>';
			echo '  bm -q <NAME>';
			echo 'list bookmarks';
			echo '  bm --list';
			echo '  bm -l';
		elif [[ $1 == --list || $1 == -l ]];then
			sed -e 's/\[\(.*\):\(.*\)\]/\1 \t\t|\2/g' ~/.bookmarks;
		else
			bm_path=$(bm --query $1);
			if [[ -d $bm_path ]];then
				builtin cd $bm_path;
			else
				echo "bookmark doesn't exist!";
			fi
		fi

	else
		bm --help;
	fi
}

user=onatbas

CONFIG=""

config=$(cat ~/.config/hub)
public_token=$(echo $config | sed -E 's/.+onatbas oauth_token: ([a-z0-9]+) .+/\1 /g')

while getopts :hr:d:s:i:p:w:n: option
do
	case "$option" in
	h)
		echo "Available options:

-n NAME		: (required) name of the repository
-r NEW_NAME	: Rename the repo to NEW_NAME
-s 1/0		: Set repo to private
-i issues 1/0	: has_issues
-p projects 1/0	: has_projects
-w wiki 1/0	: has_wiki"
		exit
		;;
	r)
		CONFIG=",\"name\": $OPTARG $CONFIG"
		;;
	d)
		CONFIG=",\"description\": $OPTARG $CONFIG"
		;;
	s)
		CONFIG=",\"private\": $OPTARG $CONFIG"
		;;
	i)
		CONFIG=",\"has_issues\": $OPTARG $CONFIG"	
		;;
	p)
		CONFIG=",\"has_projects\": $OPTARG $CONFIG"	
		;;
	w)
		CONFIG=",\"has_wiki\": $OPTARG $CONFIG"	
		;;
	n)
		NAME="$OPTARG"
		;;
	*)
		echo "Yanlis komut. -h yap haci"
		exit
		;;
	esac
done

obj="{ \"name\": \"$NAME\" $CONFIG }"

curl -X PATCH -d "$obj" https://api.github.com/repos/$user/$NAME -H "authorization: Bearer $public_token"

if [ \( $# -eq 0 \) -o \( $# -gt 1 \) ]; then
	echo "BOO!\n\nSend an argument (greater than 0 and less than 1)- The project substring (should be unique to your project) on which you are working! Wouldn't want that remove your commits or disturb them.\n"
	exit 1
fi
echo "Good argument! Started Maven build processes..."
flag=true
rm files.txt 2> /dev/null
rm errorFiles.txt 2> /dev/null
for d in */ ; do
	cd $d
	#Print name of files - Output is order of processing of files.
	echo "$d" >> ../files.txt
	if ! grep -q "$1" <<< "${PWD##*/}" 2>/dev/null; then
		git pull -q
	fi
	mvn clean install -Dmaven.test.skip=true -q -U 2> error.txt | grep "\[ERROR\]" > log.txt
	if [[ ( -s error.txt ) ]]; then
		echo "$d" >> ../errorFiles.txt
	else
		rm error.txt
	fi
	if [[ -s log.txt ]]; then
		echo "      Problem in $d's content. Doesn't run? Please check the log."
	else
		rm log.txt
	fi
	cd ..
done
echo "That's all folks."
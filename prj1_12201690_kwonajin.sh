#! /bin/bash

echo "--------------------------"
echo "User Name: ajin"
echo "Student Number: 12201690"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item’"
echo "3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’"
echo "4. Delete the ‘IMDb URL’ from ‘u.item"
echo "5. Get the data about users from 'u.user’"
echo "6. Modify the format of 'release date' in 'u.item’"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo -e "--------------------------\n"

# 함수 정의

# 1번 함수
function func1 {
	read -p "Please enter 'movie id' (1~1682): " movie_id

	awk -F\| '$1 == '"${movie_id}"'' u.item
	echo -e "\n"
}

# 2번 함수
function func2 {
	read -p "Do you want to get the data of ‘action’ genre movies from 'u.item’? (y/n): " answer

	if [ $answer = "y" ]
	then
		awk -F\| '$7 == 1 {print $1 " " $2}' u.item | sort -n -k 1 | head -10
	fi
	echo -e "\n"
}

# 3번 함수
function func3 {
	read -p "Please enter the 'movie id’(1~1682): " movie_id

	awk '$2 == '"${movie_id}"' {sum += $3; count+=1} END {printf "average rating of '"${movie_id}"': %.6g\n\n", sum/count}' u.data
}

# 4번 함수
function func4 {
	read -p "Do you want to delete the ‘IMDb URL’ from ‘u.item’? (y/n): " answer

	if [ $answer = "y" ]
	then
		sed 's/|[^|]*/|/4' u.item | head -10
	fi
	echo -e "\n"
}

# 5번 함수
function func5 {
	read -p "Do you want to get the data about users from ‘u.user’? (y/n): " answer

	if [ $answer = "y" ]
	then
		awk -F\| '{
		if($3 == "M")
			{print "user "$1" is "$2" years old male "$4}
		else
			{print "user "$1" is "$2" years old female "$4}
		}' u.user | head -10
	fi
	echo -e "\n"
}

# 6번 함수
function func6 {
	read -p "Do you want to Modify the format of ‘release data’ in ‘u.item’? (y/n): " answer

	if [ $answer = "y" ]
	then
		sed -E 's/([0-9]+)-Jan-([0-9]+)/\201\1/;s/([0-9]+)-Feb-([0-9]+)/\202\1/;s/([0-9]+)-Mar-([0-9]+)/\203\1/;s/([0-9]+)-Apr-([0-9]+)/\204\1/;s/([0-9]+)-May-([0-9]+)/\205\1/;s/([0-9]+)-Jun-([0-9]+)/\206\1/;s/([0-9]+)-Jul-([0-9]+)/\207\1/;s/([0-9]+)-Aug-([0-9]+)/\208\1/;s/([0-9]+)-Sep-([0-9]+)/\209\1/;s/([0-9]+)-Oct-([0-9]+)/\210\1/;s/([0-9]+)-Nov-([0-9]+)/\211\1/;s/([0-9]+)-Dec-([0-9]+)/\212\1/' u.item	| tail -10
	fi
	echo -e "\n"
}

# 7번 함수
function func7 {
	read -p "Please enter the ‘user id’(1~943): " user_id
	echo -e "\n"

	awk '$1 == '"${user_id}"' {print $2}' u.data | sort -n | tr '\n' '|' | sed 's/|$//'
	echo -e "\n"

	tempfile=$(mktemp)
	awk '$1 == '"${user_id}"' {print $2}' u.data | sort -n > "$tempfile"
	
	count=0
	while read -r movie_id && [ "$count" -lt 10 ]; do
		awk -F\| '$1 == '"${movie_id}"' {print $1"|"$2}' u.item
		count=$((count + 1))
	done < "$tempfile"
	echo -e "\n"

	rm "$tempfile"
}

# 8번 함수
function func8 {
	read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n): " answer
	
	if [ $answer = "y" ]
	then
		tempfile1=$(mktemp)
		awk -F\| '$2 >= 20 && $2 <30 && $4 == "programmer" {print $1}' u.user > "$tempfile1"

		tempfile2=$(mktemp)
		while read -r user_id; do
			awk '$1 == '"${user_id}"' {print $2" "$3}' u.data >> "$tempfile2" # >>는 덮어쓰기 방지
		done < "$tempfile1"

		awk '
			{movie_id = $1; rating = $2; sum[movie_id] += rating; count[movie_id]++;}
			END{for(movie_id in sum) {printf("%s %.6g\n", movie_id, sum[movie_id]/count[movie_id])}}
		' "$tempfile2" | sort -n

		rm "$tempfile1"
		rm "$tempfile2"
	fi
	echo -e "\n"
}

# 9번 함수
function func9 {
	echo "Bye!"
}

# 메인 함수
while :
do
	read -p "Enter your choice [ 1-9 ] " choice

	# 1번 실행
	if [ $choice -eq 1 ]
	then
		func1
	fi
	
	# 2번 실행
	if [ $choice -eq 2 ]
	then
		func2
	fi

	# 3번 실행
	if [ $choice -eq 3 ]
	then
		func3
	fi

	# 4번 실행
	if [ $choice -eq 4 ]
	then
		func4
	fi
	
	# 5번 실행
	if [ $choice -eq 5 ]
	then
		func5
	fi

	# 6번 실행
	if [ $choice -eq 6 ]
	then
		func6
	fi
	
	# 7번 실행
	if [ $choice -eq 7 ]
	then
		func7
	fi

	# 8번 실행
	if [ $choice -eq 8 ]
	then
		func8
	fi

	# 9번 실행
	if [ $choice -eq 9 ]
	then
		func9
		break
	fi
done

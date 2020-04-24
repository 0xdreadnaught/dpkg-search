#!/bin/bash
# use -l <list.txt> for list mode

rawarray=()
package=""
version=""

#if list or live
if [[ "$1" == "-l" ]]; then
        #check for list name
        if [[ -z "$2" ]]; then
                #no list given
                echo "Usage: dkpg-search.sh   or   dpkg-search.sh -l <list.txt>"
                exit
        else
                #process list
                echo "list given: $2"
                readarray -t rawarray < $2
        fi
else
        #run on target
        echo "running on target"
        IFS=$'\n' read -r -d '' -a rawarray < <( dpkg -l && printf '\0' )
fi

#process array
for line in "${rawarray[@]}"
do
        if [[ "$line" == *"Desired="* ]] || [[ "$line" == *"Status="* ]] || [[ "$line" == *"Err?="* ]] || [[ "$line" == *"/ Name"* ]] || [[ "$line" == *"+++-"* ]]; then
                #skip
                :
        else
                package=$(echo "$line" | awk '{print $2}' | sed 's/:/ /g' | awk '{print $1}')
                rawversion=$(echo "$line" | awk '{print $3}')
                version=$(echo "$line" | awk '{print $3}' | sed 's/:/\./g' | sed 's/`/ /g' | sed 's/:/ /g' | sed 's/_/ /g' | sed 's/+/ /g' | sed 's/~/ /g' | sed 's/ubu/ /g' | awk '{print $1}' | head -c3)
                #searchsploit
                searchresults=$(searchsploit "$package " "$version" | grep exploits)
                if [[ "$searchresults" == *"| "* ]]; then
                        echo ""
                        echo "Package: $package: $rawversion"
                        echo "$searchresults"
                fi
        fi
done

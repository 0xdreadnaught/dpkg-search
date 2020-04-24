# dpkg-search
Search dpkg package listings for possible exploits using searchsploit
The script takes the package name and a stripped down version number and runs it against Searchsploit.
It breaks apart the version label on certain special characters and then uses the remaining first 3 characters as the search version.

# usage
On the target:
./dpkg-search

List mode:
./dpkg-search -l <list.txt>

# known issues
Packages with ambiguous names such as "At" can cause a lot of false results.
If you want to remove them from the results, add `|| [[ "$line" == "ii <package name> "* ]]` to the first if statement under "process array". This should prevent the script from searching that package again.

This script will most likely produce a fair amount of false results. It's pretty much impossible to programmatically filter package versions in a uniform way to match Searchsploit labels. 

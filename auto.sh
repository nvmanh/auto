#!/bin/bash
# Install all non-obsolete android sdk packages.

function installed_sdk {
  android list target | sed '/\(Obsolete\)/d' | sed -r 's/([^0-9]*(id *)){2}.*/\2/' | sed -n 's/^[^ $]/\0/p' | sed -r 's/([^0-9]*([0-9]*)){1}.*/\2/' | sed -n 's/^[^ $]/\0/p' | sed -z 's/\n/ /'g
}

function install_sdk {
  android update sdk -u -s -a -t "$1"
}

function fetch_non_obsoled_package_indices {
  # Fetch the sdk list using non-https connections
  android list sdk -u -s -a |\
    # Filter obsoleted packages
    sed '/\(Obsolete\)/d' |\
    # Filter to take only the index number of package
    sed 's/^[ ]*\([0-9]*\).*/\1/' |\
    # Remove the empty lines
    sed -n 's/^[^ $]/\0/p'
}

for i in $(fetch_non_obsoled_package_indices)
do
    update=true;
    for j in $(installed_sdk)
    do 
        if [ "$i" == "$j" ] ;
          then update=false
        fi
        echo
    done
    if [ "$update" == true ] ; then
        echo "====================================================================="
        echo "Start to install package:  $i"
        echo "====================================================================="
        echo -e "y" | install_sdk "$i"
    fi
done

#!/bin/bash

package_name=$1
package_dir=${package_name}_archived
mkdir -p $package_dir
files_txt_name=${package_name}_deps.txt

path=$(echo "$(pwd)")
download_path=${path}/$package_dir

apt-cache depends "$package_name" | grep "Depends:" >> $files_txt_name

sed -i -e 's/[<>|:]//g' $files_txt_name
sed -i -e 's/Depends//g' $files_txt_name
sed -i -e 's/ //g' $files_txt_name

cd $download_path

while read -r line
do
    name="$line"
	apt-get download "$name"
done < "./../"${files_txt_name}""

apt-get download "$package_name"
mv "./../"${files_txt_name}"" $download_path
cd ..
#! /bin/bash

## Start variables
START_DIR=$(pwd)
OUTPUT_TYPE=$1
SRC_DIRECTORY="$START_DIR/Sources"

## End variables

## Start functions
help_message ()
{
    printf "bash build_documents.sh [FILE_TYPE]\n\n"
    printf "'help'\tPrint this help message\n"
    printf "'html'\tExport documents to HTML files in the html/ directory\n"
    printf "'pdf'\tExport documents to pdf files in the pdf/ directory\n"
}

## End Functions

## Start script
# Documents will be output in a folder named after the filetype
output_format="${OUTPUT_TYPE,,}"
output_directory="$START_DIR/$output_format"

# Set which command to execute for conversion based on file type
if [ "$output_format" == "html" ]
then
    execute="asciidoctor"
elif [ "$output_format" == "pdf" ]
then
    execute="asciidoctor-pdf"
else
    echo "Invalid format entered as argument"
    help_message
    exit 0
fi
echo "Outputing using $output_format"

# Make the file named after the file type argument
echo "Making $output_directory"
mkdir -p "$output_directory"

# Create the 
sed 's/adoc/html/' "$SRC_DIRECTORY/index.adoc" | $execute - -o "$output_directory/index.html"

# For each directory in the Sources directory...
for adoc_dir in $(find $SRC_DIRECTORY -type d -printf "%P\n")
do
    sub_output_directory="$output_directory/$adoc_dir"
    # Make a copy of the source directory in the new directory
    echo "Making $sub_output_directory"
    mkdir -p "$sub_output_directory"
    # For every Asciidoc file in the sub-directory...
    for adoc_file in $(find "$SRC_DIRECTORY/$adoc_dir" -type f -name "*.adoc" -printf "%f\n")
    do
        file_name="${adoc_file##*/}"
        file_title="${adoc_file%.adoc}"
        old_file_path="$SRC_DIRECTORY/$adoc_dir/$adoc_file"
        new_file_path="$output_directory/$adoc_dir/$file_title.html"

        echo "Generating $new_file_path"
        #echo "sed -i -e 's/adoc/html/' $old_file_path | $execute - -o $new_file_path" 
        sed 's/adoc/html/' "$old_file_path" | $execute - -o "$new_file_path"
    done
done

# Copy images and things to the output directory
echo "Copying assets"
cp -r "$SRC_DIRECTORY/images/" "$output_directory/"

echo "Document generation completed"

## End script

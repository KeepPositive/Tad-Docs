#! /bin/bash

## Start variables
START_DIR=$(pwd)
OUTPUT_TYPE=$1
## End variables

## Start functions
help_message ()
{
    printf "bash build_documents.sh [FILE_TYPE]\n\n"
    printf "'help'\tPrint this help message\n"
    printf "'html'\tExport documents to HTML files in the html/ directory\n"
    printf "'pdf'\tExport documents to pdf files in the pdf/ directory\n"
}

generate_documents ()
{
    # Documents will be output in a folder named after the filetype
    output_format=${$OUTPUT_TYPE,,}
    source_directory="$START_DIR/Sources"
    output_directory="$START_DIR/$OUTPUT_TYPE"
    # Set which command to execute for conversion based on file type
    if [ $OUTPUT_TYPE -eq "html" ]
    then
        execute="asciidoctor"
    else if [ "$OUTPUT_TYPE" -eq "pdf"]
    then
        execute="asciidoctor-pdf"
    else
        echo "Invalid format entered as argument"
        help_message
        exit 0
    fi
    echo "Outputing using $output_format"
    # Make the file named after the file type argument
    mkdir "$output_directory"
    # For each directory in the Sources directory...
    for adoc_dir in $(find $source_directory -type d -printf "%f/n")
    do
        sub_output_directory="$output_directory/$adoc_dir"
        # Make a copy of the source directory in the new directory
        mkdir -pv "$sub_output_directory"
        # For every Asciidoc file in the sub-directory...
        for adoc_file in $(find $sub_output_directory -type f           \
                                                      -name "*.adoc"    \
                                                      -printf "%P\n")
        do
            echo "Name: ${s##*/}"
            echo "Title: ${s%.adoc}"
        done
    done

}

## Start script
case "$OUTPUT_TYPE" in
"html" | "HTML")
    echo "Creating html documents"
    generate_documents "html"
;;
"pdf" | "PDF")
    echo "Creating html documents"
    generate_documents "pdf"
;;
esac
## End script

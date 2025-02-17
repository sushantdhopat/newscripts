target=$1
grep -rl -E '$target' /Users/sushantdhopat/desktop/nuclei-templates/ | grep '\.yaml$' > filtered_templates.txt
mkdir $target 

# Loop through the list of template paths and copy the content to the new folder
while IFS= read -r template_path; do
    template_name=$(basename "$template_path")
    cat "$template_path" > "$target/$template_name"
done < filtered_templates.txt

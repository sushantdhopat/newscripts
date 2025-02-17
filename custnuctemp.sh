# Create a new folder for storing the templates
grep -rl -E 'swagger' /Users/sushantdhopat/desktop/nuclei-templates/ | grep '\.yaml$' > filtered_templates.txt
mkdir swagger

# Loop through the list of template paths and copy the content to the new folder
while IFS= read -r template_path; do
    template_name=$(basename "$template_path")
    cat "$template_path" > "swagger/$template_name"
done < filtered_templates.txt


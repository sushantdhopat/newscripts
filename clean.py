import re

# Function to clean URLs and save to a file
def clean_urls(input_file, output_file):
    cleaned_urls = []

    with open(input_file, 'r') as file:
        urls = file.readlines()

        for url in urls:
            cleaned_url = re.sub(r'\s*\[[^\]]*\]', '', url)
            cleaned_urls.append(cleaned_url.strip())  # Remove leading/trailing whitespaces

    with open(output_file, 'w') as output:
        for cleaned_url in cleaned_urls:
            output.write("%s\n" % cleaned_url)

# Input file name from user
input_filename = input("Enter the name of the input file containing URLs: ")

# Output file name
output_filename = 'validclnd.txt'

# Clean URLs and save to a file
clean_urls(input_filename, output_filename)


import sys
import json
import glob

def process_json_file(json_file_path):
    try:
        with open(json_file_path) as json_file:
            data = json.load(json_file)
            for result in data['results']:
                length = result['length']
                url = result['url']
                status = result['status']
                host_header = result['host']
                print(f"{length} {url} {status} {host_header}")
    except FileNotFoundError:
        print(f"File not found: {json_file_path}")
    except json.JSONDecodeError:
        print(f"Invalid JSON file: {json_file_path}")

if len(sys.argv) < 2:
    print("Usage: python3 filename.py <json_file(s)>")
    sys.exit(1)

json_files = []
for pattern in sys.argv[1:]:
    json_files.extend(glob.glob(pattern))

if not json_files:
    print("No JSON files found.")
    sys.exit(1)

for json_file_path in json_files:
    process_json_file(json_file_path)


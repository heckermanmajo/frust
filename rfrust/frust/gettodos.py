import os

def traverse_folder(folder_path):
    for root, dirs, files in os.walk(folder_path):
        for file_name in files:
            file_path = os.path.join(root, file_name)
            process_file(file_path)

def process_file(file_path):
    try:
        with (open(file_path, 'rb') as file):
            lines = str(file.read()).split('\\n')
            for line_number, line in enumerate(lines, start=1):
                if ("todo" in line or "TODO" in line or "fixme" in line or "FIXME" in line\
                  )and "--" in line:
                    print(f"{file_path}:{line_number}: {line.strip()}")
    except IOError as e:
        print(f"Error opening file: {file_path}\n{e}")

# Example usage: Traverse the current directory
traverse_folder('.')
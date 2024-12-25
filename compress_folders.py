import os
import zipfile

# 输入和输出路径
input_dir = "./zip"  # 替换为你的文件夹路径
output_dir = "./zipped"  # 替换为你的压缩输出路径

# 确保输出目录存在
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# 记录未压缩的文件夹
skipped_folders = []

# 遍历文件夹并压缩
for folder_name in os.listdir(input_dir):
    folder_path = os.path.join(input_dir, folder_name)

    if os.path.isdir(folder_path):
        zip_file_path = os.path.join(output_dir, f"{folder_name}.zip")
        
        try:
            # 压缩文件夹
            with zipfile.ZipFile(zip_file_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
                has_files = False
                for root, _, files in os.walk(folder_path):
                    for file in files:
                        file_path = os.path.join(root, file)
                        arcname = os.path.relpath(file_path, folder_path)
                        zipf.write(file_path, arcname)
                        has_files = True

                # 如果文件夹是空的，则跳过压缩
                if not has_files:
                    skipped_folders.append(folder_name)
                    os.remove(zip_file_path)

            print(f"Compressed: {folder_name} -> {zip_file_path}")
        except Exception as e:
            print(f"Failed to compress {folder_name}: {e}")
            skipped_folders.append(folder_name)

print("\nCompression Complete!")
print(f"Skipped folders (empty or error): {len(skipped_folders)}")
if skipped_folders:
    print("Skipped folders:")
    for folder in skipped_folders:
        print(f"- {folder}")

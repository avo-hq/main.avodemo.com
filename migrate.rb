require "active_support/inflector"

def migrate_resources
  # Get the directory path and the replacement string from the command line
  dir_path = './app/avo/resources'
  # replacement_string = ARGV[1]

  # Get a list of all files in the directory
  files = Dir.entries(dir_path)

  # Loop through each file in the directory
  files.each do |file|
    # Skip over directories and hidden files
    next if File.directory?(file) || file.start_with?(".")

    # Get the file extension
    file_ext = File.extname(file)

    # Get the file name without the extension
    file_name = File.basename(file, file_ext)

    new_file_name = file_name.gsub("_resource", "")

    # Read the contents of the file
    file_contents = File.read("#{dir_path}/#{file}")
    new_klass_def = "class Avo::Resources::#{new_file_name.to_s.classify} < Avo::BaseResource"
    # puts ["new_klass_def->", new_klass_def].inspect

    # Replace the string in the contents
    new_contents = file_contents.gsub(/.*< Avo::BaseResource/, new_klass_def)

    # Construct the new file name with the replacement string
    new_file_name = "#{new_file_name}#{file_ext}"

    # Write the updated contents to a new file with the new name
    File.write("#{dir_path}/#{new_file_name}", new_contents)

    # Delete the original file
    File.delete("#{dir_path}/#{file}")
  end
end

def migrate_actions
  # Get the directory path and the replacement string from the command line
  dir_path = './app/avo/actions'
  # replacement_string = ARGV[1]

  # Get a list of all files in the directory
  files = Dir.entries(dir_path)

  # Loop through each file in the directory
  files.each do |file|
    # Skip over directories and hidden files
    next if File.directory?(file) || file.start_with?(".")

    # Get the file extension
    file_ext = File.extname(file)

    # Get the file name without the extension
    file_name = File.basename(file, file_ext)

    new_file_name = file_name.gsub("_action", "")

    # Read the contents of the file
    file_contents = File.read("#{dir_path}/#{file}")
    new_klass_def = "class Avo::Actions::#{new_file_name.to_s.classify} < Avo::BaseAction"
    # puts ["new_klass_def->", new_klass_def].inspect

    # Replace the string in the contents
    new_contents = file_contents.gsub(/.*< Avo::BaseAction/, new_klass_def)

    # Construct the new file name with the replacement string
    new_file_name = "#{new_file_name}#{file_ext}"

    # Write the updated contents to a new file with the new name
    File.write("#{dir_path}/#{new_file_name}", new_contents)

    # Delete the original file
    File.delete("#{dir_path}/#{file}")
  end
end

def migrate_filters
  # Get the directory path and the replacement string from the command line
  dir_path = './app/avo/filters'
  # replacement_string = ARGV[1]

  # Get a list of all files in the directory
  files = Dir.entries(dir_path)

  # Loop through each file in the directory
  files.each do |file|
    # Skip over directories and hidden files
    next if File.directory?(file) || file.start_with?(".")

    # Get the file extension
    file_ext = File.extname(file)

    # Get the file name without the extension
    file_name = File.basename(file, file_ext)

    new_file_name = file_name.gsub("_filter", "")

    # Read the contents of the file
    file_contents = File.read("#{dir_path}/#{file}")
    new_klass_def = "class Avo::Filters::#{new_file_name.to_s.classify} < Avo::BaseFilter"
    # puts ["new_klass_def->", new_klass_def].inspect

    # Replace the string in the contents
    new_contents = file_contents.gsub(/.*< Avo::BaseFilter/, new_klass_def)

    # Construct the new file name with the replacement string
    new_file_name = "#{new_file_name}#{file_ext}"

    # Write the updated contents to a new file with the new name
    File.write("#{dir_path}/#{new_file_name}", new_contents)

    # Delete the original file
    File.delete("#{dir_path}/#{file}")
  end
end

# migrate_resources
# migrate_actions
migrate_filters
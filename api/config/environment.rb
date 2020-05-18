# frozen_string_literal: true

PROJECT_ROOT = File.expand_path('..', __dir__)
ENVIRONMENT = (ENV['ENVIRONMENT'] || 'development').tap do |env|
  case File.basename($PROGRAM_NAME)
  when 'rake'
    ENV['RAKE_ENV'] = env
  when 'rackup'
    ENV['RACK_ENV'] = env
  end
end

# @yield [path, file] Calls the block on each "*.rb" file found.
# @yeildparam path [array] File path, split into individual path elements.
# @yeildparam file [array] File path as a string
# @yeildreturns [bool] File will be required if the block returns true.
def require_dir(*dir_elements)
  dir = File.join(dir_elements)
  $LOAD_PATH.unshift(dir)
  Dir.glob(File.join('**', '*.rb'), base: dir) do |file|
    next if block_given? && !yield(file.split(File::SEPARATOR), file)
    require file
  end
end

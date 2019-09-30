require "fileutils"

IRB.conf[:SAVE_HISTORY] = 1000

virtual_env = ENV["VIRTUAL_ENV"]
history_dir = File.join(ENV["HOME"], ".local", "irb-history")
FileUtils.mkdir_p(history_dir)

if virtual_env.nil?
  IRB.conf[:HISTORY_FILE] = File.join(history_dir, "irb-history")
else
  virtual_env_name = File.basename(virtual_env)
  IRB.conf[:HISTORY_FILE] = File.join(
    history_dir, "irb-history-#{virtual_env_name}")
end

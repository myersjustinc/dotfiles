IRB.conf[:SAVE_HISTORY] = 1000

virtual_env = ENV["VIRTUAL_ENV"]
if virtual_env.nil?
  IRB.conf[:HISTORY_FILE] = File.join(ENV["HOME"], ".irb-history")
else
  virtual_env_name = File.basename(virtual_env)
  IRB.conf[:HISTORY_FILE] = File.join(
    ENV["HOME"], ".irb-history-#{virtual_env_name}")
end

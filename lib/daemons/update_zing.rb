#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do 
  $running = false
end
lastUpdateTime = Time.now - 3 * 3600

while($running) do
  
  # Replace this with your code
  Rails.logger.info "waiting... #{Time.now}.\n"

  if Time.now - lastUpdateTime > 3 * 3600
    Rails.logger.info "Running update"
    Song.update_zing_url
    Rails.logger.info "Done updating"

    lastUpdateTime = Time.now
  end
  sleep 1000
end

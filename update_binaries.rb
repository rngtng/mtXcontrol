#!/usr/bin/ruby

require 'rubygems'
#require 'net/github-upload'

DEBUG = true

# setup
login = `git config github.user`.chomp  # your login for github
token = `git config github.token`.chomp # your token for github
repos = 'mtXcontrol'                    # your repos name (like 'taberareloo')
#gh = Net::GitHub::Upload.new(
#  :login => login,
#  :token => token
#)

all_os = { :linux => "Linux", :macosx => "Mac OS X (32bit)", :windows => "Windows"}

def exec(command)
 # puts command
  system(command) #unless DEBUG
end

all_os.each do |os, human_os|
  file = "latest_cubeXcontrol_and_firmware_#{os}.zip"

  # rename
  next unless exec "mv application.#{os} cubeXcontrol"

  if( os == :macosx )  #patch Mac Os X file to use java 1.6
      exec "mv cubeXcontrol/mtXcontrol.app/Contents/Info.plist cubeXcontrol/mtXcontrol.app/Contents/Info_old.plist"
      exec "sed 's/1\\\.5/1\\\.6/g' cubeXcontrol/mtXcontrol.app/Contents/Info_old.plist > cubeXcontrol/mtXcontrol.app/Contents/Info.plist"
      # copy icon
      exec "cp -f sketch.icns cubeXcontrol/mtXcontrol.app/Contents/Resources/sketch.icns"
  end 
  
  # copy firmware
  exec "mkdir cubeXcontrol/firmware"
  exec "cp ~/Sites/java/rainbowduino/firmware/*.* cubeXcontrol/firmware"
  
  #zip file
  exec "zip -x .DS_Store -r #{file} cubeXcontrol/"
      
  direct_link = DEBUG ? "debug" : gh.replace( :repos => repos, :file  => file, :description => "Latest mtXcontrol - #{human_os}")
  
  #exec "rm #{file}"
  exec "rm -rf cubeXcontrol"
  
  puts "########################  #{human_os} done, uploaded to: #{direct_link} ########################"  
end


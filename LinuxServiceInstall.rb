require 'fileutils'

def main
	usage unless ARGV[0] 
        if ARGV[0] == 'install'
		install
	end 
	if ARGV[0] == 'remove'
		remove
	end 
end

def usage
	puts 'Fibonacci REST Linux Service Installer Usage'
	puts "'ruby LinuxServiceInstall.rb install' - installs the Fibonacci REST Service"
	puts "'ruby LinuxServiceInstall.rb remove' - removes the Fibonacci Rest Service"
end

def install

begin
        Dir.mkdir('/opt/FibonacciService') unless ((File.exists? '/opt/FibonacciService') && (File.directory? '/opt/FibonacciService'))
rescue StandardError => err
        puts "Unable to create installation directory. Run via sudo. Error => #{err.message}"
end

#Copy the core files to /opt/FibonacciService
FileUtils.cp 'FibonacciService.rb', '/opt/FibonacciService/FibonacciService.rb'
FileUtils.cp 'FibonacciLinuxService.rb', '/opt/FibonacciService/FibonacciLinuxService.rb'
FileUtils.cp 'FibonacciLinuxServiceControl.rb', '/opt/FibonacciService/FibonacciLinuxServiceControl.rb'

#create the log directory
FileUtils.mkdir '/opt/FibonacciService/log' unless File.exists? '/opt/FibonacciService/log'
#make sure the permisisons are set correctly for the application folder and the log folder
FileUtils.chmod_R 0660, '/opt/FibonacciService'


#Copy the init script to /etc/init.d
FileUtils.cp 'FibonacciServiceLinux_init', '/etc/init.d/FibonacciService'
FileUtils.chmod 0554, '/etc/init.d/FibonacciService'
#register the service for default runlevels
puts `update-rc.d FibonacciService defaults`

#start the service
puts `/etc/init.d/FibonacciService start`
puts `/etc/init.d/FibonacciService status`
exit!
end

def remove
puts `/etc/init.d/FibonacciService stop`
puts `update-rc.d -f FibonacciService remove`
FileUtils.rm_rf '/opt/FibonacciService'
FileUtils.rm '/etc/init.d/FibonacciService'
exit!
end

main


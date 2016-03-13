require 'win32/service'
require 'FileUtils'

include Win32

#set the service and display name as well as locate the ruby executable
SERVICE_NAME = 'FibonacciRESTService'
DISPLAY_SERVICE_NAME = 'Fibonacci REST Service'
RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])#.gsub('/', '\\')
INSTALL_DIR = 'C:\Program Files\FibonacciService'

#entry point to check arguments to see if we're installing or uninstalling. If no args passed show usage 
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
	puts "'ruby WindowsServiceInstaller.rb install' - installs the Fibonacci REST Service"
	puts "'ruby WindowsServiceInstaller.rb remove' - removes the Fibonacci Rest Service"
end

# Create the Windows Service
def install
	
	begin 
		FileUtils.mkdir INSTALL_DIR unless File.exists? INSTALL_DIR
	rescue StandardError => err 
		puts "Cannot install, unable to create installation directory. Most likely you don't have rights to create #{INSTALL_DIR}. Error => #{err.message}"
		exit!
	end
	FileUtils.cp 'FibonacciService.rb', INSTALL_DIR
	FileUtils.cp 'FibonacciWin32Service.rb', INSTALL_DIR
  FileUtils.mkdir "#{INSTALL_DIR}/log" unless File.exists? "#{INSTALL_DIR}/log"

	if !Service.exists? SERVICE_NAME
	begin 
		Service.create({
		  :service_name        => SERVICE_NAME,
		  :service_type       => Service::WIN32_OWN_PROCESS,
		  :description        => 'RESTFUL service providing items from the Fibonacci sequence',
		  :start_type         => Service::AUTO_START,
		  :error_control      => Service::ERROR_NORMAL,
		  :binary_path_name   => "#{RUBY}.exe -C\"#{INSTALL_DIR}\" FibonacciWin32Service.rb",
		  :load_order_group   => 'Network',
		  :dependencies       => [''],
		  :display_name       => DISPLAY_SERVICE_NAME
		}) 
		puts 'Service Created Successfully'
		rescue StandardError => err
			puts "Failed to create service, error => #{err.message}"
		
	end
	begin
		Service.start SERVICE_NAME
		puts "Service #{SERVICE_NAME} started successfully"
		rescue StandardError => err
			puts "Failed to start service, error => #{err.message}"
	end

	else
		puts 'Service is already installed'
	end

end

# uninstall the service
def remove
	puts "Service #{SERVICE_NAME} doesn't exist" unless Service.exists? SERVICE_NAME
	return unless Service.exists? SERVICE_NAME
	puts "Removing Service #{SERVICE_NAME}" unless !Service.exists? SERVICE_NAME
	begin 
		Service.stop SERVICE_NAME unless Service.status(SERVICE_NAME).current_state == 'stopped'
		$i = 0
		#wait for the service to stop before deleting it
		while $i < 5 do
			sleep 10
			break if Service.status(SERVICE_NAME).current_state == "stopped"
           i+=1
		end
		Service.delete SERVICE_NAME unless !Service.exists? SERVICE_NAME
		rescue StandardError => err
		puts "Service #{SERVICE_NAME} could not be removed, error => #{err.message}"
		exit!
	end

	#confirm the service was deleted successfully
	if !Service.exists? SERVICE_NAME 
		puts "Service #{SERVICE_NAME} was removed successfully"
		FileUtils.rm_rf INSTALL_DIR
	else
		puts "Service #{SERVICE_NAME} was not removed successfully"
	end
	
end

#entry
main
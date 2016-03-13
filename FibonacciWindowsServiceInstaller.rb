require 'win32/service'

include Win32

#set the service and display name as well as locate the ruby executable
SERVICE_NAME = 'FibonacciRESTService'
DISPLAY_SERVICE_NAME = 'Fibonacci REST Service'
RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name']).sub(/.*\s.*/m, '"\&"')
#entry point to check arguments in case we're being asked to uninstall the service
def main
	install_service unless ARGV[0] == 'remove_service'
	remove_service if ARGV[0] == 'remove_service'
end

# Create the Windows Service
def install_service
	if !Service.exists? SERVICE_NAME
	begin 
		Service.create({
		  :service_name        => SERVICE_NAME,
		  :service_type       => Service::WIN32_OWN_PROCESS,
		  :description        => 'RESTFUL service providing items from the Fibonacci sequence',
		  :start_type         => Service::AUTO_START,
		  :error_control      => Service::ERROR_NORMAL,
		  :binary_path_name   => "#{RUBY}.exe -C#{Dir.pwd} FibonacciWin32Service.rb",
		  :load_order_group   => 'Network',
		  :dependencies       => [''],
		  :display_name       => DISPLAY_SERVICE_NAME
		}) 
		puts 'Service Created'
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
def remove_service
	puts "Service #{SERVICE_NAME} doesn't exist" unless Service.exists? SERVICE_NAME
	return unless Service.exists? SERVICE_NAME
	puts "Removing Service #{SERVICE_NAME}" unless !Service.exists? SERVICE_NAME
	begin 
		Service.delete SERVICE_NAME unless !Service.exists? SERVICE_NAME
		rescue StandardError => err
		puts "Service #{SERVICE_NAME} could not be removed, error => #{err.message}"
	end
	#confirm the service was deleted successfully
	if !Service.exists? SERVICE_NAME 
		puts "Service #{SERVICE_NAME} was removed successfully"
	else
		puts "Service #{SERVICE_NAME} was not removed successfully"
	end
	
end

main
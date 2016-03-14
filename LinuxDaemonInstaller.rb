require 'fileutils'

#entry point to check arguments and determine whether to install or uninstall. Show usage if no args passed
LISTEN_PORT = ARGV[1] || 80
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
  puts 'Fibonacci REST Linux Daemon Installer Usage'
  puts "'ruby LinuxDaemonInstaller.rb install [Listen Port]' - installs the Fibonacci REST Daemon. Listen Port defaults to 80 if not supplied."
  puts "'ruby LinuxDaemonInstaller.rb remove' - removes the Fibonacci Rest Daemon"
end

#install the daemon
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
  init_script = IO.read('FibonacciServiceLinux_init')
  init_script.gsub! '"$@"', "$1 -- #{LISTEN_PORT}"
  IO.write('/etc/init.d/FibonacciService', init_script )

  FileUtils.chmod 0554, '/etc/init.d/FibonacciService'
  #register the daemon for default runlevels
  puts `update-rc.d FibonacciService defaults`

  #start the daemon
  puts `/etc/init.d/FibonacciService start`
  puts `/etc/init.d/FibonacciService status`
  exit!
end

#stop and uninstall the daemon
def remove
  puts `/etc/init.d/FibonacciService stop`
  puts `update-rc.d -f FibonacciService remove`
  FileUtils.rm_rf '/opt/FibonacciService'
  FileUtils.rm '/etc/init.d/FibonacciService'
  exit!
end

main


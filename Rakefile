require 'vagrant'


task :hello do
  env = Vagrant::Environment.new
  raise "Must run `vagrant up`" if !env.primary_vm.created?
  raise "Must be running!" if !env.primary_vm.vm.running?
  env.primary_vm.ssh.execute do |ssh|
    ssh.exec!("echo 'Hello BuyPass' > hello.txt") 
  end
end
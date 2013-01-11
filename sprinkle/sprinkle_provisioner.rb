class SprinkleProvisioner < Vagrant::Provisioners::Base
  def prepare
    
  end

  def provision!
    vm.ssh.execute do |ssh|
     ssh.exec!('gem list | grep "i18n (0.5.0)" ;if [ $? == "1" ]; then sudo gem install i18n --version "0.5.0"; fi;')
     ssh.exec!('gem list | grep "sprinkle (0.3.3)" ;if [ $? == "1" ]; then sudo gem install sprinkle --version "0.3.3"; fi;')
     
     ssh.exec!("sudo sprinkle -v -c -s /vagrant/utviklingsmiljo/sprinkle/install.rb") do |channel, type, data|
           env.ui.info("#{data}") if type != :exit_status
     end
      
   end
  end
end

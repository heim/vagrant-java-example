package :git, :provides => :scm do
  description 'Git Distributed Version Control'
  apt "git-core"
   verify do
    has_executable "git"
  end
end

package :maven do
  version "2.2.1"
  binary "http://apache.uib.no//maven/binaries/apache-maven-#{version}-bin.tar.gz" do
    prefix   '/usr/local'
    archives '/usr/local/sources'
    post :install, [
      "sudo ln -s /usr/local/apache-maven-#{version}/bin/mvn /usr/bin/mvn",
      "echo 'export M2_HOME=/usr/local/apache-maven-#{version};export M2=$M2_HOME/bin' | sudo -E tee -a ~/.bashrc"]
  end
  verify do
    has_executable "mvn"
  end
  requires :java
end

package :java6, :provides => :java do
  description "Java development toolkit"
  apt %w( sun-java6-jdk ) do
      pre :install, 
      ['echo "sun-java6-jdk shared/accepted-sun-dlj-v1-1 boolean true" | sudo -E debconf-set-selections']
         
      post :install, ['echo "export JAVA_HOME=/usr/lib/jvm/java-6-sun" | sudo -E tee -a ~/.bashrc ']
  end
  requires :lucid_partner_repository
  verify do
    has_executable "java"
  end
  
end

package :lucid_partner_repository do
  apt 'python-software-properties' do
    post :install, 
        ['add-apt-repository "deb http://archive.canonical.com/ lucid partner"',
          'apt-get update']
  end
  verify do
    has_executable "add-apt-repository"
  end
end

package :jetty, :provides => :servlet_container do
  description "Jetty Servlet Container"
  requires :java
  apt "jetty" do
    post :install, ["sudo mv /etc/default/jetty /etc/default/jetty.old && sudo sed 's/NO_START=1/NO_START=0/g' /etc/default/jetty.old | sudo -E tee /etc/default/jetty",
                   "sudo /etc/init.d/jetty start"]
  end
  
  
  verify do
    has_file "/etc/init.d/jetty"
  end
end


package :hsqldb, :provides => :database do
  apt "hsqldb-server"
  requires :java
  
  verify do
    has_file "/etc/init.d/hsqldb-server"
  end
end


policy :java_stack, :roles => :development do
  #requires :java6
  #requires :servlet_container
  requires :scm 
  #requires :maven
  #requires :database                    
end

deployment do 
  delivery :local do 
    
  end
  
  source do
     prefix   '/usr/local'
     archives '/usr/local/sources'
     builds   '/usr/local/build'
   end
   
   binary do
     prefix   '/usr/local'
     archives '/usr/local/sources'
    end
end
#chef :: default recipe

provides :rundeck_server

action :create do
    bash 'Rundeck install and start' do
      code <<-EOH
        sudo su
        echo "start process!!"
        yes Y y | sudo apt-get -f install
        echo "curl install!!"
        yes Y y | sudo apt-get install curl
        echo "start java install!!"
        yes Y y | sudo apt-get install python-software-properties
        yes Y y | sudo add-apt-repository ppa:webupd8team/java
        echo "update!!"
        yes Y y | sudo apt-get update
        yes Y y | sudo apt-get install oracle-java8-installer
        echo -ne '\n' | sudo update-alternatives --config java
        sudo echo "JAVA_HOME="/usr/lib/jvm/java-8-oracle"" >> /etc/environment
        source /etc/environment
        echo $JAVA_HOME
        echo "check java !"
        java -version
        echo "download rundeck !!"
        sleep 30 | wget http://dl.bintray.com/rundeck/rundeck-deb/rundeck_2.10.8-1-GA_all.deb
        echo "install rundeck!!"
        dpkg -i rundeck_2.10.8-1-GA_all.deb
        echo "start rundeck !!"
        sudo sed --in-place '/localhost/d' /etc/rundeck/rundeck-config.properties
        public_host=$(curl -s 169.254.169.254/latest/meta-data/public-hostname ; echo)
        sudo echo "grails.serverURL=http://$public_host:4440" >> /etc/rundeck/rundeck-config.properties
        sudo service rundeckd status
        sudo service rundeckd restart
        sudo netstat -antlp | grep 4440
        echo "check UI!!"
      EOH
    end
end
action :start do
    bash 'Rundeck install and start' do
      code <<-EOH
        service rundeckd status 
        service rundeckd start && service rundeckd status
      EOH
    end
    #notifies :start, "rundeck_server[rundeckd]", :immediately
end
action :stop do
    bash 'Rundeck install and start' do
      code <<-EOH
        service rundeckd status 
        service rundeckd stop && service rundeckd status
        curl -I http://localhost:4440
      EOH
    end
    notifies :stop, "rundeck_server[rundeckd]", :immediately
end
action :restart do
    bash 'Rundeck install and start' do
      code <<-EOH
        service rundeckd status 
        service rundeckd restart && service rundeckd status
        sleep 120 && curl -I http://localhost:4440
      EOH
    end
    notifies :restart, "rundeck_server[rundeckd]", :immediately
end

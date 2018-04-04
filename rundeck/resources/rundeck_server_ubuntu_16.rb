#
#chef :: default recipe
#
provides :rundeck_server_16

action :create do
    bash 'Rundeck install and start' do
      code <<-EOH
        sudo su
        mkdir -p /home/ubuntu/test_000
        touch /home/ubuntu/test.sh
        sudo add-apt-repository ppa:webupd8team/java -y
        sudo dpkg --configure -a
        sudo apt-get update -y
        yes y | sudo apt-get install oracle-java8-installer -y
        sudo apt-get install oracle-java8-set-default -y
        echo -ne '\n' | sudo update-alternatives --config java
        sudo echo "JAVA_HOME="/usr/lib/jvm/java-8-oracle"" >> /etc/environment
        source /etc/environment
        wget http://dl.bintray.com/rundeck/rundeck-deb/rundeck_2.10.8-1-GA_all.deb
        dpkg -i rundeck_2.10.8-1-GA_all.deb
        sudo service rundeckd status
        sudo service rundeckd start
        sudo netstat -antlp | grep 4440
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

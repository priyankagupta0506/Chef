#
#chef :: default recipe
#
provides :rundeck_server_java

action :create do
    bash 'Rundeck install and start' do
      code <<-EOH
        sudo su
        mkdir -p /home/ubuntu/test_000
        echo -ne '\n' | sudo add-apt-repository ppa:webupd8team/java
        mkdir -p /home/ubuntu/test_001
        sudo apt-get update -y
        mkdir -p /home/ubuntu/test_002
        yes y | sudo apt-get install oracle-java8-installer -y
        mkdir -p /home/ubuntu/test_003
        yes y | sudo apt-get install oracle-java8-set-default -y
        mkdir -p /home/ubuntu/test_004
        echo -ne '\n' | sudo update-alternatives --config java
        mkdir -p /home/ubuntu/test_005
        sudo echo "JAVA_HOME="/usr/lib/jvm/java-8-oracle"" >> /etc/environment
        source /etc/environment
        mkdir -p /home/ubuntu/test_006
        wget http://dl.bintray.com/rundeck/rundeck-deb/rundeck_2.10.8-1-GA_all.deb
        dpkg -i rundeck_2.10.8-1-GA_all.deb
        mkdir -p /home/ubuntu/test_007
        sudo service rundeckd status
        sudo service rundeckd start
        mkdir -p /home/ubuntu/test_008
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

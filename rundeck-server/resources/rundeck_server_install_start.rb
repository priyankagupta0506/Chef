#chef :: default recipe

provides :rundeck_server

action :create do
    bash 'Rundeck install and start' do
      code <<-EOH
        sudo su
        sudo apt-get update
        yes y | sudo apt-get install oracle-java8-installer
        sudo apt-get install openjdk-8-jdk
        echo "check java !"
        java -version
        echo "download rundeck !!"
        sleep 30 | wget http://dl.bintray.com/rundeck/rundeck-deb/rundeck_2.10.8-1-GA_all.deb
        echo "install rundeck!!"
        dpkg -i rundeck_2.10.8-1-GA_all.deb
        echo "start rundeck !!"
        service rundeckd status && service rundeckd start
        echo "check UI!!"
        curl -I http://localhost:4440
      EOH
    end
end
action :start do
    bash 'Rundeck install and start' do
      code <<-EOH
        service rundeckd status 
        service rundeckd start && service rundeckd status
        curl -I http://localhost:4440
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

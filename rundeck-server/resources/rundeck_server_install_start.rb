#chef :: default recipe

provides :rundeck_server

action :create do
    bash 'Rundeck install and start' do
      code <<-EOH
        sudo su
        apt-get install openjdk-8-jdk
        java -version
        wget http://dl.bintray.com/rundeck/rundeck-deb/rundeck_2.10.8-1-GA_all.deb
        dpkg -i rundeck_2.10.8-1-GA_all.deb
        service rundeckd status 
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
    notifies :start, rundeck-server[rundeckd], :immediately
end
action :stop do
    bash 'Rundeck install and start' do
      code <<-EOH
        service rundeckd status 
        service rundeckd stop && service rundeckd status
        curl -I http://localhost:4440
      EOH
    end
    notifies :stop, rundeck-server[rundeckd], :immediately
end
action :restart do
    bash 'Rundeck install and start' do
      code <<-EOH
        service rundeckd status 
        service rundeckd restart && service rundeckd status
        sleep 120 && curl -I http://localhost:4440
      EOH
    end
    notifies :restart, rundeck-server[rundeckd], :immediately
end

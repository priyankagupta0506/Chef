#
#chef :: default recipe

provides :mysql_service_direct

action :create do
    bash 'Mysql install and start' do
      code <<-EOH
        sudo su
        sudo apt-get update -y
        export DEBIAN_FRONTEND=noninteractive
        sudo apt-get install mysql-server -y
        sudo mysql_secure_installation
        mysqladmin -u root password changeme
        mysql --version
        touch test_2.sh
        sudo service mysql status
      EOH
    end
end
action :start do
    bash 'Mysql install and start' do
      code <<-EOH
        service mysql status 
        service mysql start && service mysql status
      EOH
    end
    #notifies :start, "mysql_server_direct[mysql]", :immediately
end
action :stop do
    bash 'Mysql install and start' do
      code <<-EOH
        service mysql status 
        service mysql stop && service mysql status
      EOH
    end
    notifies :stop, "mysql_server_direct[mysql]", :immediately
end
action :restart do
    bash 'Mysql install and start' do
      code <<-EOH
        service mysql status 
        service mysql restart && service mysql status
      EOH
    end
    notifies :restart, "mysql_server_direct[mysql]", :immediately
end

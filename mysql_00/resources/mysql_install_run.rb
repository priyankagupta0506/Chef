#
#chef :: default recipe

provides :mysql_service_direct

action :create do
    bash 'Mysql install and start' do
      code <<-EOH
        sudo su
        sudo apt-get update -y
        echo "mysql-server mysql-server/root_password password mysql" | debconf-set-selections
        echo "mysql-server mysql-server/root_password_again password mysql" | debconf-set-selections
        sudo apt-get install mysql-server-5.5 -y
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

#
#chef :: default recipe

provides :mysql_service_direct

action :create do
    bash 'Mysql install and start' do
      code <<-EOH
        sudo su
        sudo apt-get update -y
        touch test_0.sh
        sudo apt-get install mysql-server -y
        sudo mysql_secure_installation
        touch test_1.sh
        mysql --version
        touch test_2.sh
        sudo mysql_install_db
        touch test_3.sh
        sudo service mysql status
        sudo service mysql start
        sudo netstat -antlp | grep 3306
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

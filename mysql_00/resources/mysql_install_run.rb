#
#chef :: default recipe

provides :mysql_server_direct

action :create do
    bash 'Mysql install and start' do
      code <<-EOH
        sudo su
        hostname -f
        sudo apt-get update -y
        sudo apt-get upgrade -y
        sudo apt-get install mysql-server-5.5 -y
        sudo mysql_secure_installation
        mysql --version
        sudo mysql_install_db 
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

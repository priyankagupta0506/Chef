#
provides :mysql_master
default_action :create

action :create do
    bash 'Mysql master start' do
      code <<-EOH
        sudo su
        mysql -u root --pmysql -e "FLUSH PRIVILEGES;"
        mysql -u root --pmysql -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%' IDENTIFIED BY 'mysql';"
        mysql -u root --pmysql -e "FLUSH PRIVILEGES;"
        mysql -u root --pmysql -e "show master status;"
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

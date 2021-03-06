#
provides :mysql_master
default_action :create

action :create do
    bash 'Mysql master start' do
      code <<-EOH
        sudo su
        sudo sed --in-place '/bind-address/d' /etc/mysql/my.cnf
        sudo sed --in-place '/log_bin/d' /etc/mysql/my.cnf        
        echo "[mysqld]" >> /etc/mysql/my.cnf
        echo "server-id           = 1" >> /etc/mysql/my.cnf
        echo "log_bin           = /var/log/mysql/mysql-bin.log" >> /etc/mysql/my.cnf
        echo "binlog_do_db           = test1" >> /etc/mysql/my.cnf
        bind=$(wget -qO- http://instance-data/latest/meta-data/public-ipv4)
        sudo service mysql restart
        mysql -u root --password="mysql" -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%' IDENTIFIED BY 'mysql';"
        mysql -u root --password="mysql" -e "FLUSH PRIVILEGES;"
        mysql -u root --password="mysql" -e "create database test1;"
        mysql -u root --password="mysql" -e "use test1;"
        mysql -u root --password="mysql" -e "FLUSH TABLES WITH READ LOCK;"
        mysql -u root --password="mysql" -e "SHOW MASTER STATUS;"
        mysql -u root --password="mysql" -e "UNLOCK TABLES;"
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


##echo "bind-address           = $bind" >> /etc/mysql/my.cnf

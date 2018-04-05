#
#
provides :mysql_slave
default_action :create

action :create do
    bash 'Mysql master start' do
      code <<-EOH
        sudo su
        mysql -u root -pmysql -e "create database test1;"
        echo "server-id               = 2" >> /etc/mysql/my.cnf
        echo "log_bin                 = /var/log/mysql/mysql-bin.log" >> /etc/mysql/my.cnf
        echo "relay-log               = /var/log/mysql/mysql-relay-bin.log" >> /etc/mysql/my.cnf
        echo "replicate_do_db           = test1" >> /etc/mysql/my.cnf
        echo "binlog_do_db            = test1" >> /etc/mysql/my.cnf
        sudo service mysql restart
        mysql -u root -pmysql -e "CHANGE MASTER TO MASTER_HOST = 'x.x.x.x', MASTER_USER = 'repl', MASTER_PASSWORD = 'mysql', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = xxx;"
        mysql -u root -pmysql -e "start slave;"
        mysql -u root -pmysql -e "SHOW SLAVE STATUS\G;"
        mysql -u root -pmysql -e"SET GLOBAL SQL_SLAVE_SKIP_COUNTER = 1; SLAVE START;"
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

#
#
provides :mysql_slave
default_action :create

action :create do
    bash 'Mysql slave start' do
      code <<-EOH
        sudo su
        touch log_pos.sh
        echo "mysql -u root --password="mysql" -ANe "SHOW MASTER STATUS;"" >> log_pos.sh
        mysql -u root -pmysql -e "show databases;"
        sudo sed --in-place '/log_bin/d' /etc/mysql/my.cnf
        echo "[mysqld]" >> /etc/mysql/my.cnf
        echo "server-id               = 2" >> /etc/mysql/my.cnf
        echo "log_bin                 = /var/log/mysql/mysql-bin.log" >> /etc/mysql/my.cnf
        echo "relay-log               = /var/log/mysql/mysql-relay-bin.log" >> /etc/mysql/my.cnf
        echo "replicate_do_db           = test1" >> /etc/mysql/my.cnf
        echo "binlog_do_db            = test1" >> /etc/mysql/my.cnf
        sudo service mysql restart
        
        Master_DNS="x.x.x.x"
        scp -i ~/.ssh/mysql.pem /home/priyankagu/Desktop/pos.sh ubuntu@Master_DNS:/home/ubuntu
        pos=$(ssh -i ~/.ssh/mysql.pem ubuntu@Master_DNS "chmod 755 pos.sh | ./pos.sh")
        echo $pos

        mysql -u root -pmysql -e "STOP SLAVE;"
        mysql -u root -pmysql -e "CHANGE MASTER TO MASTER_HOST = 'Master_DNS', MASTER_USER = 'repl', MASTER_PASSWORD = 'mysql', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = $pos;"
        mysql -u root -pmysql -e "START SLAVE;"
        mysql -u root -pmysql -e "SHOW SLAVE STATUS;"
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

#
#
provides :mysql_slave
default_action :create

action :create do
    bash 'Mysql master start' do
      code <<-EOH
        sudo su
        mysql -u root -h 127.0.0.1 -pmysql -e "CHANGE MASTER TO MASTER_HOST = '35.171.206.5', MASTER_USER = 'repl', MASTER_PASSWORD = 'mysql', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = 868;"
        mysql -u root -h 127.0.0.1 -pmysql -e "start slave;"
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

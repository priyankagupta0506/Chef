#
#
provides :mysql_slave
default_action :create

action :create do
    bash 'Mysql master start' do
      code <<-EOH
        sudo su
        mysql -u root -pmysql -e "CHANGE MASTER TO MASTER_HOST = 'x.x.x.x', MASTER_USER = 'repl', MASTER_PASSWORD = 'mysql', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = xxx;"
        mysql -u root -pmysql -e "start slave;"
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

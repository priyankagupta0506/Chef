#
#chef :: default recipe

provides :jenkins_server_16

action :create do
    bash 'Jenkins install and start' do
      code <<-EOH
        sudo su
        
        yes y | wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
        echo "add in source list!!"
        echo "deb https://pkg.jenkins.io/debian binary/" >> /etc/apt/sources.list
        echo "update again !!"
        yes y Y | apt-get update 
        yes y Y | apt-get install jenkins
        sudo service jenkins status | sudo service jenkins start
      EOH
    end
end
action :start do
    bash 'Jenkins install and start' do
      code <<-EOH
        service jenkins status 
        service jenkins start
      EOH
    end
    #notifies :start, "jenkins_server[jenkins]", :immediately
end
action :stop do
    bash 'Jenkins install and start' do
      code <<-EOH
        service jenkins status 
        service jenkins stop && service jenkins status
      EOH
    end
    notifies :stop, "jenkins_server[jenkins]", :immediately
end
action :restart do
    bash 'Jenkins install and start' do
      code <<-EOH
        service jenkins status 
        service jenkins restart && service jenkins status
      EOH
    end
    notifies :restart, "jenkins_server[jenkins]", :immediately
end

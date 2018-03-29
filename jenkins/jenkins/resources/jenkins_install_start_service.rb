#chef :: default recipe

provides :jenkins_server

action :create do
    bash 'Jenkins install and start' do
      code <<-EOH
        sudo su
        echo "start process!!"
        yes Y y | sudo apt-get -f install
        yes Y y | sudo apt-get install curl
        echo "start java install!!"
        yes Y y | sudo apt-get install python-software-properties
        yes Y y | sudo add-apt-repository ppa:webupd8team/java
        echo "update!!"
        yes Y y | sudo apt-get update
        yes Y y | sudo apt-get install oracle-java8-installer
        echo -ne '\n' | sudo update-alternatives --config java
        sudo echo "JAVA_HOME="/usr/lib/jvm/java-8-oracle"" >> /etc/environment
        source /etc/environment
        echo $JAVA_HOME
        echo "\n \n \n check java !"
        java -version
        echo "download jenkins !! \n \n" | sleep 20
        yes y | wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
        echo "add in source list!!"
        echo "deb https://pkg.jenkins.io/debian binary/" >> /etc/apt/sources.list
        echo "update again !!"
        yes y Y | apt-get update | echo "apt install !!"
        yes y Y | apt-get install jenkins
        echo "start Jenkins !!"
        service jenkins status && service jenkins start
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

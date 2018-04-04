#
#chef :: default recipe
#
provides :rundeck_server_java

action :create do
    bash 'Rundeck install and start' do
      code <<-EOH
        sudo su
        mkdir -p /home/ubuntu/test_000
        sudo apt install openjdk-8-jre -y
        mkdir -p /home/ubuntu/test_001
        sudo apt install openjdk-8-jdk -y
        sudo apt-get update -y
        mkdir -p /home/ubuntu/test_002
        echo -ne '\n' | sudo update-alternatives --config java
        mkdir -p /home/ubuntu/test_005
        sudo echo "JAVA_HOME="/usr/lib/jvm/java-8-oracle"" >> /etc/environment
        source /etc/environment
        mkdir -p /home/ubuntu/test_006
        java -version
        javac -version
      EOH
    end
end



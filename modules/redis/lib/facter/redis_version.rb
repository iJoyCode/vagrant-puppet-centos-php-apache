require 'facter'

Facter.add("redis_version", :timeout => 20) do
    confine :osfamily => "Debian"

    setcode do

        dpkg = `which apt-cache 2> /dev/null`.chomp
        if dpkg == ''
            dpkg = '/usr/bin/apt-cache'
        end

        redis_version = Facter::Util::Resolution.exec('/usr/bin/redis-server --version')
        if redis_version.nil?
            redis_version = Facter::Util::Resolution.exec(dpkg+" show redis-server 2> /dev/null | /bin/grep -i 'version:' | /usr/bin/awk '{print $2}'").strip
        end

        case redis_version
            when /2\.8\.[0-9]/
                #set version to 2.8
                redis_version = '2.8.x'
            when /2\.6\.[0-9]/
                #set version to 2.6
                redis_version = '2.6.x'
            when /2\.4\.[0-9]/
                #set version to 2.4
                redis_version = '2.4.x'
            when /2\.2\.[0-9]/
                #set version to 2.2
                redis_version = '2.2.x'
            else
                redis_version = 'nil'
        end
        redis_version
    end
end

Facter.add("redis_version", :timeout => 20) do
    confine :osfamily => "RedHat"

    setcode do

        yum = `which yum 2> /dev/null`.chomp
        if yum == ''
            yum = '/usr/bin/yum'
        end

        redis_version = Facter::Util::Resolution.exec('/usr/sbin/redis-server --version')
        if redis_version.nil?
            redis_version = Facter::Util::Resolution.exec(yum+" info redis 2> /dev/null | /bin/grep '^Version' | /bin/awk -F ':' '{print $2}'").strip
        end

        case redis_version
            when /2\.8\.[0-9]/
                #set version to 2.8
                redis_version = '2.8.x'
            when /2\.6\.[0-9]/
                #set version to 2.6
                redis_version = '2.6.x'
            when /2\.4\.[0-9]/
                #set version to 2.4
                redis_version = '2.4.x'
            when /2\.2\.[0-9]/
                #set version to 2.2
                redis_version = '2.2.x'
            else
                redis_version = 'nil'
        end
        redis_version
  end
end

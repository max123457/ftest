task default: %w[test]

task :test do
  ruby "test/unittest.rb"
end

task :deploy do
    command = %q{ 
        cd /home/ezo/projects/ftest/ftest && \
        git reset --hard origin/gh-pages && \
        GIT_SSH=/home/ezo/projects/ftest/my_git_ssh_wrapper git pull && \
        source ../profile && \
        bundle install && \
        touch ../restart.txt
    }
    sh "ssh #{ENV['HOST']} '#{command}'"
end

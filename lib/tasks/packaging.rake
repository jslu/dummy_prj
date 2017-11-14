namespace 'packaging' do
  desc "Put source code into a tgz"
  task :tarball do
    sh %{ rm -f source_tarball.tgz.cpt source_tarball.tgz }
    sh %{ tar --exclude='Dockerfile' --exclude='fetch_passphrase.sh' --exclude='nginx.conf' --exclude='.git' --exclude='.gitignore' --exclude='source_tarball.tgz' --exclude='source_tarball.tgz.cpt' -zcf source_tarball.tgz . }
  end

  desc "Encrypt the tgz"
  task :encrypt, [:passphrase] => [:tarball] do |t, args|
    args.with_defaults(passphrase: 'iloveayla')
    sh %{ ccencrypt -K #{args.passphrase} source_tarball.tgz }
  end

  desc "Generate encrypted tarball"
  task :gen_encrypted_tgz => [:tarball, :encrypt] do
  end

  desc "Make docker image"
  task :build_docker_image => [:environment, :gen_encrypted_tgz] do
    sh %{ docker build -t jslu/passenger-dummy:#{Consts::VERSION} . }
    sh %{ docker push jslu/passenger-dummy:#{Consts::VERSION} }
  end
end


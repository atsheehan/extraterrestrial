require "gli"
require "yaml"

module ET
  class Runner
    include GLI::App

    attr_reader :cwd

    def initialize(cwd = Dir.pwd)
      @cwd = cwd
    end

    def go(args)
      version VERSION

      desc "Initialize current directory as challenge work area."
      command :init do |c|
        c.flag [:u, :user], desc: "Username"
        c.flag [:t, :token], desc: "Login token"
        c.flag [:h, :host], desc: "Server hosting the challenges"

        c.action do |_global_options, options, _cmdargs|
          config = {
            "username" => options[:user],
            "token" => options[:token],
            "host" => options[:host]
          }

          File.write(File.join(cwd, ".et"), config.to_yaml)
        end
      end

      desc "List available challenges."
      command :list do |c|
        c.action do |_global_options, _options, _cmdargs|
          api = API.new(host)
          results = api.list_challenges

          results[:challenges].each do |challenge|
            puts challenge[:title]
            puts challenge[:slug]
          end
        end
      end

      desc "Download challenge to your working area."
      command :get do |c|
        c.action do |_global_options, _options, cmdargs|
          api = API.new(host)

          cmdargs.each do |slug|
            challenge = api.get_challenge(slug)
            archive = api.download_file(challenge[:archive_url])

            system("tar zxf #{archive} -C #{cwd}")
            system("rm #{archive}")
          end
        end
      end

      desc "Submit the challenge in this directory."
      command :submit do |c|
        c.action do |_global_options, _options, _cmdargs|
          api = API.new(host)
          api.submit_challenge(cwd)
        end
      end

      run(args)
    end

    def host
      config.host
    end

    def config
      @config ||= Config.new(cwd)
    end
  end
end

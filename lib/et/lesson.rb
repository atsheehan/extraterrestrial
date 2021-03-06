require "pathname"
require "securerandom"

module ET
  class Lesson
    attr_reader :cwd

    def initialize(cwd)
      @cwd = cwd
    end

    def archive!
      if exists?
        filepath = random_archive_path

        cmd = "tar zcf #{filepath} -C #{dir}"

        ignored_files.each do |file|
          cmd += " --exclude='#{file}'"
        end

        cmd += " ."

        if system(cmd)
          filepath
        else
          nil
        end
      else
        nil
      end
    end

    def dir
      @dir ||= find_lesson_dir(cwd)
    end

    def slug
      File.basename(dir)
    end

    def exists?
      !dir.nil?
    end

    def ignored_files
      (config["ignore"] || []) + [".lesson.yml"]
    end

    protected

    def config
      @config ||= YAML.load_file(File.join(dir, ".lesson.yml"))
    end

    def random_archive_path
      File.join(Dir.mktmpdir, "#{SecureRandom.hex}.tar.gz")
    end

    def find_lesson_dir(current_dir)
      path = File.join(current_dir, ".lesson.yml")

      if File.exists?(path)
        current_dir
      elsif current_dir == "." || Pathname.new(current_dir).root?
        nil
      else
        find_lesson_dir(File.dirname(current_dir))
      end
    end
  end
end

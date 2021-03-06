require_relative '../../lib/logging'
require_relative '../../lib/common/exceptions'
require_relative '../../lib/common/colorize'
require 'artii'

class JobTemplate
  include Logging
  include Colorize

  attr_reader :name

  def initialize(name)
    @name = name
    @a = Artii::Base.new :font => 'roman'

  end

  def process
    begin
      config = TaskModuleHelper.get_task_module[@name.to_s]
      process_task(config)
    rescue HookrJobError => e
      logger.error "Error hit in #{caller[0][/`.*'/][1..-2]}.process(), ERROR: [#{e.message}]"
      raise e
    end
  end

  def process_task(config)
    raise 'Not implemented.'
  end

  protected

  def validate_config(config, key_list)
    key_list.each do |key|
      raise HookrInvalidConfigError.new "Config missing key: [#{key}]" unless config.has_key? key
    end
  end
end

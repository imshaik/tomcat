require 'serverspec'
require 'docker'

set :backend, :docker

RSpec.configure do |c|
  # Use color in STDOUT
  c.color = true
  #config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  c.tty = true

  # Use the specified formatter
  c.formatter = :documentation # :progress, :html,
                                    # :json, CustomFormatterClass
  c.before(:suite) do
  end
end

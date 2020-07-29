# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Load Enviroment Variables
env_file = File.join(Rails.root, '.env.yml')

if File.exists?(env_file)
  env_variables = YAML.load(File.open(env_file))[Rails.env]

  if env_variables.present?
    env_variables.each do |key, value|
      ENV[key.to_s] = value.to_s
    end
  end
end

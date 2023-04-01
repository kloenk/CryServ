import Config

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
env =
  if Kernel.macro_exported?(Config, :config_env, 0) do
    Config.config_env()
  else
    Mix.env()
  end

import_config "#{env}.exs"

if File.exists?("./config/#{env}.secrets.exs") do
  import_config("#{env}.secrets.exs")
end

config :cryserv, env: env

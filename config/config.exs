import Config

{api_host, api_path} = case System.get_env("ZUUL") do
  "sf" ->
    {"ansible.softwarefactory-project.io", "/zuul/api"}
  nil ->
    {"dashboard.zuul.ansible.com", "/api/tenant/ansible"}
end

config :list_jobs,
  api_host: api_host,
  api_path: api_path,
  results_dir: "./results"

# config valid only for current version of Capistrano
lock '3.7.2'

set :rbenv_ruby, File.read('.ruby-version').strip
set :application, 'just-ask'
set :repo_url, 'git@github.com:evmorov/just-ask.git'
set :deploy_to, '/home/deployer/just-ask'
set :deploy_user, 'deployer'

append(
  :linked_files,
  'config/database.yml',
  'config/cable.yml',
  'config/thinking_sphinx.yml',
  '.env'
)
append(
  :linked_dirs,
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'public/system',
  'public/uploads'
)

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end

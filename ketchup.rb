require 'github_api'


class Ketchup

  def initialize(username, access_token)
    @oauth_token = access_token
    @github = Github.new(oauth_token: @oauth_token)
    @username = username
  end


  def create_repo
    @github.repos.create "name": 'ketchup-repo',
    "description": "This is your ketchup repo",
      "homepage": "https://github.com",
      "private": false,
      "has_issues": true,
      "has_wiki": true,
      "has_downloads": true
  end


  def find_ketchup_repo
    begin
      @github.repos(user: @username, repo: 'ketchup-repo').get
    rescue Github::Error::NotFound
      false
    end
  end


  def ketchup_repo
    find_ketchup_repo || create_repo
  end


  def get_commits(repo)
    @github.repos(user: @username, repo: repo).commits.list.map { |commit|
       {date: commit.commit.committer.date,
        name: commit.commit.message }
     }
  end


  def clone_ketchup
    `git clone #{ketchup_repo.ssh_url}`
  end


  def update_readme(date, repo)
    File.open('README', 'a+') do |file|
      file.write "#{date} Mirror commit msg for #{repo}\n"
    end
  end


  def fake_commit(date)
    `git add .`
    `GIT_AUTHOR_DATE='#{date}' GIT_COMMITTER_DATE='#{date}' git commit -m 'Private commit'`
  end


  def push
    # set upstream version of ketchup-repo
    Dir.chdir('ketchup-repo') do
      `git push -u origin master`
    end
  end


  def remove_ketchup_folder
    `rm -rf ketchup-repo`
  end


  def ketchup_history(repo)
    Dir.chdir('ketchup-repo') do
      # loop through original commits
      get_commits(repo).reverse.each do |commit|
        date = commit[:date]
        update_readme(date, repo)
        fake_commit(date)
      end
    end
  end


  def forks
    forked_repos = @github.repos.list.select(&:fork).map(&:name)
  end


  def run
    clone_ketchup
    forks.each do |fork|
      ketchup_history(fork)
    end
    push
    remove_ketchup_folder
  end

  
end


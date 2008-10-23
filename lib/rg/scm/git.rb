module Rg
  class Git
    def self.clone(repos, branch=nil)
      `git clone #{repos}`
      
      if branch
        `cd #{repos.split('/').last}/`
        `git checkout #{branch}`
      end
    end
  end
end
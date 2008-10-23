module Rg
  class Svn
    def self.checkout(repos, branch = nil)
      `svn checkout #{repos}/#{branch || "trunk"}`
    end
  end
end
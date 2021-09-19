defmodule Crash.Support.Github.FakeCommit do
  @moduledoc false

  alias Faker.Company.En
  alias Faker.StarWars

  def generate do
    %{
      ref: generate_ref(),
      before: "6113728f27ae82c7b1a177c8d03f9e96e0adf246",
      after: "0000000000000000000000000000000000000000",
      created: false,
      deleted: true,
      forced: false,
      base_ref: nil,
      compare: "https://github.com/Codertocat/Hello-World/compare/6113728f27ae...000000000000",
      commits: [],
      head_commit: %{
        id: generate_head_commit_id(),
        tree_id: "31b122c26a97cf9af023e9ddab94a82c6e77b0ea",
        message: genenate_message(),
        timestamp: generate_timestamp(),
        author: %{
          username: generate_username(),
          email: "21031067+Codertocat@users.noreply.github.com"
        },
        committer: %{
          name: "Codertocat",
          email: "21031067+Codertocat@users.noreply.github.com"
        }
      },
      repository: %{
        id: 186_853_002,
        node_id: "MDEwOlJlcG9zaXRvcnkxODY4NTMwMDI=",
        name: generare_repository(),
        full_name: "lucazulian/crash-example",
        private: false,
        owner: %{
          name: "Codertocat",
          email: "21031067+Codertocat@users.noreply.github.com",
          login: "Codertocat",
          id: 21_031_067,
          node_id: "MDQ6VXNlcjIxMDMxMDY3",
          avatar_url: "https://avatars1.githubusercontent.com/u/21031067?v=4",
          gravatar_id: "",
          url: "https://api.github.com/users/Codertocat",
          html_url: "https://github.com/Codertocat",
          followers_url: "https://api.github.com/users/Codertocat/followers",
          following_url: "https://api.github.com/users/Codertocat/following{/other_user}",
          gists_url: "https://api.github.com/users/Codertocat/gists{/gist_id}",
          starred_url: "https://api.github.com/users/Codertocat/starred{/owner}{/repo}",
          subscriptions_url: "https://api.github.com/users/Codertocat/subscriptions",
          organizations_url: "https://api.github.com/users/Codertocat/orgs",
          repos_url: "https://api.github.com/users/Codertocat/repos",
          events_url: "https://api.github.com/users/Codertocat/events{/privacy}",
          received_events_url: "https://api.github.com/users/Codertocat/received_events",
          type: "User",
          site_admin: false
        },
        html_url: "https://github.com/Codertocat/Hello-World",
        description: nil,
        fork: false,
        url: "https://github.com/Codertocat/Hello-World",
        forks_url: "https://api.github.com/repos/Codertocat/Hello-World/forks",
        keys_url: "https://api.github.com/repos/Codertocat/Hello-World/keys{/key_id}",
        collaborators_url:
          "https://api.github.com/repos/Codertocat/Hello-World/collaborators{/collaborator}",
        teams_url: "https://api.github.com/repos/Codertocat/Hello-World/teams",
        hooks_url: "https://api.github.com/repos/Codertocat/Hello-World/hooks",
        issue_events_url:
          "https://api.github.com/repos/Codertocat/Hello-World/issues/events{/number}",
        events_url: "https://api.github.com/repos/Codertocat/Hello-World/events",
        assignees_url: "https://api.github.com/repos/Codertocat/Hello-World/assignees{/user}",
        branches_url: "https://api.github.com/repos/Codertocat/Hello-World/branches{/branch}",
        tags_url: "https://api.github.com/repos/Codertocat/Hello-World/tags",
        blobs_url: "https://api.github.com/repos/Codertocat/Hello-World/git/blobs{/sha}",
        git_tags_url: "https://api.github.com/repos/Codertocat/Hello-World/git/tags{/sha}",
        git_refs_url: "https://api.github.com/repos/Codertocat/Hello-World/git/refs{/sha}",
        trees_url: "https://api.github.com/repos/Codertocat/Hello-World/git/trees{/sha}",
        statuses_url: "https://api.github.com/repos/Codertocat/Hello-World/statuses/{sha}",
        languages_url: "https://api.github.com/repos/Codertocat/Hello-World/languages",
        stargazers_url: "https://api.github.com/repos/Codertocat/Hello-World/stargazers",
        contributors_url: "https://api.github.com/repos/Codertocat/Hello-World/contributors",
        subscribers_url: "https://api.github.com/repos/Codertocat/Hello-World/subscribers",
        subscription_url: "https://api.github.com/repos/Codertocat/Hello-World/subscription",
        commits_url: "https://api.github.com/repos/Codertocat/Hello-World/commits{/sha}",
        git_commits_url: "https://api.github.com/repos/Codertocat/Hello-World/git/commits{/sha}",
        comments_url: "https://api.github.com/repos/Codertocat/Hello-World/comments{/number}",
        issue_comment_url:
          "https://api.github.com/repos/Codertocat/Hello-World/issues/comments{/number}",
        contents_url: "https://api.github.com/repos/Codertocat/Hello-World/contents/{+path}",
        compare_url:
          "https://api.github.com/repos/Codertocat/Hello-World/compare/{base}...{head}",
        merges_url: "https://api.github.com/repos/Codertocat/Hello-World/merges",
        archive_url: "https://api.github.com/repos/Codertocat/Hello-World/{archive_format}{/ref}",
        downloads_url: "https://api.github.com/repos/Codertocat/Hello-World/downloads",
        issues_url: "https://api.github.com/repos/Codertocat/Hello-World/issues{/number}",
        pulls_url: "https://api.github.com/repos/Codertocat/Hello-World/pulls{/number}",
        milestones_url: "https://api.github.com/repos/Codertocat/Hello-World/milestones{/number}",
        notifications_url:
          "https://api.github.com/repos/Codertocat/Hello-World/notifications{?since,all,participating}",
        labels_url: "https://api.github.com/repos/Codertocat/Hello-World/labels{/name}",
        releases_url: "https://api.github.com/repos/Codertocat/Hello-World/releases{/id}",
        deployments_url: "https://api.github.com/repos/Codertocat/Hello-World/deployments",
        created_at: 1_557_933_565,
        updated_at: "2019-05-15T15:20:41Z",
        pushed_at: 1_557_933_657,
        git_url: "git://github.com/Codertocat/Hello-World.git",
        ssh_url: "git@github.com:Codertocat/Hello-World.git",
        clone_url: "https://github.com/Codertocat/Hello-World.git",
        svn_url: "https://github.com/Codertocat/Hello-World",
        homepage: nil,
        size: 0,
        stargazers_count: 0,
        watchers_count: 0,
        language: "Ruby",
        has_issues: true,
        has_projects: true,
        has_downloads: true,
        has_wiki: true,
        has_pages: true,
        forks_count: 1,
        mirror_url: nil,
        archived: false,
        disabled: false,
        open_issues_count: 2,
        license: nil,
        forks: 1,
        open_issues: 2,
        watchers: 0,
        default_branch: "master",
        stargazers: 0,
        master_branch: "master"
      },
      pusher: %{
        name: "Codertocat",
        email: "21031067+Codertocat@users.noreply.github.com"
      },
      sender: %{
        login: "Codertocat",
        id: 21_031_067,
        node_id: "MDQ6VXNlcjIxMDMxMDY3",
        avatar_url: "https://avatars1.githubusercontent.com/u/21031067?v=4",
        gravatar_id: "",
        url: "https://api.github.com/users/Codertocat",
        html_url: "https://github.com/Codertocat",
        followers_url: "https://api.github.com/users/Codertocat/followers",
        following_url: "https://api.github.com/users/Codertocat/following{/other_user}",
        gists_url: "https://api.github.com/users/Codertocat/gists{/gist_id}",
        starred_url: "https://api.github.com/users/Codertocat/starred{/owner}{/repo}",
        subscriptions_url: "https://api.github.com/users/Codertocat/subscriptions",
        organizations_url: "https://api.github.com/users/Codertocat/orgs",
        repos_url: "https://api.github.com/users/Codertocat/repos",
        events_url: "https://api.github.com/users/Codertocat/events{/privacy}",
        received_events_url: "https://api.github.com/users/Codertocat/received_events",
        type: "User",
        site_admin: false
      }
    }
  end

  defp normalize(string), do: string |> String.replace(" ", "-") |> String.downcase()

  def generate_ref do
    head = En.bs() |> normalize()
    "refs/heads/#{head}"
  end

  def generare_repository do
    StarWars.planet() |> normalize()
  end

  def genenate_message do
    StarWars.quote()
  end

  def generate_head_commit_id do
    UUID.uuid4()
  end

  def generate_username do
    StarWars.character() |> normalize()
  end

  def generate_timestamp do
    DateTime.now!("Etc/UTC") |> DateTime.add(-60, :second) |> DateTime.to_iso8601()
  end
end

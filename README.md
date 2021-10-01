![CI workflow](https://github.com/solubris/insync/actions/workflows/ci.yaml/badge.svg)
[![version](https://img.shields.io/github/v/release/solubris/insync)](https://img.shields.io/github/v/release/solubris/insync)

# Sync files

Helps keep files in sync between repositories by pushing changes in a src repo to a dest repo.

NOTE: repo's don't have to be forks, can be completely disparate

## Example action

Create the action in the source project:

    .github/workflows/main.yml

With the contents:

    on:
      push:
        branches: [master]
    
    jobs:
      sync:
        runs-on: ubuntu-latest
        steps:
          - id: sync
            uses: solubris/insync@1.2.0
            with:
              repositories: the-dst-repo
              token: ${{ secrets.TOKEN }}
              files: |
                .gitignore
                .editorconfig

NOTE: requires the token used to access the dest repo to be saved in the secrets in the source repo
Alternatively, the secret could be saved at the organisation level

# Future enhancements

- user/email of source commit could be used for pushing to the dest repo - done
- delete branch if job failed
  - only do this if the branch wasn't already there
- dont overwrite if dst file is newer
  - this might add undue complexity
- test adding new files - done
- test adding files in subdir - done
- collating changes - multiple changes can be collated to an existing branch - done
  - what about the pr description, should subsequent changes update the pr description?
    - could add a comment to the pr
  - existing branch might be out of date with head branch
    - could merge from head
    - could delete and recreate
      - dependabot recreates the branch
      - only recreate the branch is pr-branch has been specified
        - what if pr-branch=master?
        - if the branch was created by insync, then should be safe to recreate
        - but how to know if it was created by insync?
        - perhaps don't allow the pr-branch to be set
          - but pr-branch is useful tests
          - could make it an env instead of input so it's a hidden var
- allow push to master, so no pr required - works by setting pr-branch=''
- allow auto merge pr's
- templates - perform replacement on templated files
- allow for different dest paths:
  - eg: dependabot.yml=.github/dependabot.yml
- sync entire dir
  - but what about if dest has extra files in the dir, should they be removed?
- split into multiple steps in action.yaml

Multiple destinations:
- action could be setup for each dest
- or can have one action that supports multiple dest's
  - this would be faster as src would only be checked out once for all dest's

Customize the PR:
- labels
- title
- description
- reviewers
- etc
- provide link to the src repo/change

# Alternatives

- https://github.com/marketplace/actions/file-sync
- https://github.com/marketplace/actions/assets-sync
- https://github.com/marketplace/actions/sync-files
- https://github.com/marketplace/actions/files-sync-action
- https://github.com/marketplace/actions/repo-selective-sync
- https://github.com/marketplace/actions/github-file-sync
- https://github.com/marketplace/actions/template-repository-sync


Benefits over alternatives:
- Doesn't require the github checkout action so the jobs are simpler and more efficient
- Doesn't use docker so actions will run in seconds
- Doesn't use nodeJs
- Uses original commit author/message in commits to destination repo's
- Provides link to the original commit
- Uses hub command line tool rather than direct http requests for creating PR's


Unidirectional
Master -> slave 1
       -> slave 2
       -> slave 3

Bidirectional
Slave 1 -> Master
Master -> slave 2
       -> slave 3

To sync workflow files, token needs workflow permissions

! [remote rejected] testUpdateDir -> testUpdateDir (refusing to allow a Personal Access Token to create or update workflow `.github/workflows/ci.yaml` without `workflow` scope)

use post action so that it is always executed for cleanup

paths can be used in the job definition:

    on:
      push:
        paths:
          - '**.js'

# Internal vs external actions

current dir:
/home/runner/work/insync-src/insync-src

this will be empty for run an external action, but will be the contents of the repo for internal action

External action
GITHUB_ACTION=sync
GITHUB_ACTION_PATH=/home/runner/work/_actions/solubris/insync/master

Internal action:
GITHUB_ACTION=__self
GITHUB_ACTION_PATH=/home/runner/work/insync/insync/./



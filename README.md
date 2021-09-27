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
      sync_job:
        runs-on: ubuntu-latest
        steps:
          - id: sync
            uses: solubris/insync@1.0.0
            with:
              dst-repository: 'the-org/the-dst-repo'
              dst-token: ${{ secrets.TOKEN }}
              files: '.gitignore .editorconfig'

NOTE: requires the token used to access the dest repo to be saved in the secrets in the source repo
Alternatively, the secret could be saved at the organisation level

# Future enhancements

- user/email of source commit could be used for pushing to the dest repo - done
- delete branch if job failed
- dont overwrite if dst file is newer
- test adding new files - done
- test adding files in subdir
- collating changes - multiple changes can be collated to an existing branch
- allow push to master - so no pr required
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



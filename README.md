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

- user/email of source commit could be used for pushing to the dest repo
- delete branch if job failed
- dont overwrite if dst file is newer
- test adding new files
- collating changes - multiple changes can be collated to an existing branch
- allow push to master - so no pr required
- allow auto merge pr's
- templates - perform replacement on templated files

Multiple destinations:
- action could be setup for each dest
- or can have one action that supports multiple dests

Customize the PR:
- labels
- title
- description
- reviewers
- etc
- provide link to the src repo/change



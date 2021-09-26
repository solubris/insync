# Sync files

Helps keep files in sync between repositories by pushing changes in a src repo to a dest repo.

NOTE: repo's don't have to be forks, can be completely disparate

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



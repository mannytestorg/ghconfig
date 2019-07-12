#!/bin/bash

# Use the given template repo as an initial commit for the
# given (presumably empty) new repo.
# Requires that a github token be set in the script's
# environment as GITHUB_TOKEN.

template_repo=$1
new_repo=$2

template_repo_url=https://github.com/$template_repo
new_repo_url=https://$GITHUB_TOKEN@github.com/$new_repo

tmpdir=$(mktemp -dt init_from_template.XXXXXX)

git clone $template_repo_url $tmpdir

template_sha1=$(git -C $tmpdir rev-parse origin/master)

git -C $tmpdir remote add init $new_repo_url
git -C $tmpdir checkout --orphan init origin/master
git -C $tmpdir commit -m "Initial commit" -m "From $template_repo_url $template_sha1"
git -C $tmpdir push -f init HEAD:master

rm -rf $tmpdir

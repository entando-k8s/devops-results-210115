#precondition: old devops-results has been backed up, and cloned out locally
#precondition: devops-results-template has been forked to devops-results and cloned locally
#post actions: setup repo permissions and gh-pages
oc scale deployment jenkins-x-controllerbuild -n jx --replicas=0
old_repo_dir=${1:-devops-results-bup}
new_repo_dir=devops-results
#Construct the logs branch
git checkout -b logs
cd ../${old_repo_dir}
git checkout origin/logs --track
find ./ -type d -name "master" -exec mkdir -p ../${new_repo_dir}/{} \;
find ./ -type d -name "master" -exec sh -c "ls -td {}/* | awk 'NR==1'|xargs -I@  cp -rf @ ../${new_repo_dir}/@" \;
cd ../${new_repo_dir}
git add -A
git commit -m "First commit after trim"

#Construct the gh-pages branch
git checkout -b gh-pages
cd ../${old_repo_dir}
git checkout origin/gh-pages --track
find ./ -type d -name "master" -exec mkdir -p ../${new_repo_dir}/{} \;
find ./ -type d -name "master" -exec sh -c "ls -td {}/* | awk 'NR==1'|xargs -I@  cp -rf @ ../${new_repo_dir}/@" \;
cd ../${new_repo_dir}
git add -A
git commit -m "First commit after trim"

#Construct empty branches
git checkout -b tests
git checkout -b coverage
git push origin --all

#Spin JX up again
oc scale deployment jenkins-x-controllerbuild -n jx --replicas=1
